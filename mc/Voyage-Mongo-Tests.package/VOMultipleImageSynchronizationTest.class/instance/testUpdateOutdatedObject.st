tests
testUpdateOutdatedObject
	| dog dogId repository |
	
	"clean up"
	repository := VOMongoTestResource new setUp repository.
	repository dropDatabase.

	"set up scenario"
	50 milliSeconds asDelay wait.
	repository := VOMongoTestResource new setUp repository.
	dog := VOTestDog new name: 'carola'; yourself.
	repository save: dog.
	dogId := repository idOf: dog.

	FileStream stdout << Smalltalk session hash; << '# ImageMaster begin'; cr; flush.
	
	"FORKED IMAGE: change dog name to bar"
	ImageWorker 
		do: [ 
			| workerRepo |
			FileStream stdout << Smalltalk session hash; << '# ImageWorker begin'; cr; flush.
			workerRepo := VOMongoTestResource new setUp repository.
			dog := workerRepo selectOne: VOTestDog where: (Dictionary with: '_id' -> dogId).
			dog name: 'bar'. 
			workerRepo save: dog.
			FileStream stdout << Smalltalk session hash; << '# ImageWorker end'; cr; flush. ]
		within: 5 seconds 
		onTimeout: [].
	5 seconds asDelay wait.

	FileStream stdout << Smalltalk session hash; << '# ImageMaster end'; cr; flush.

	self 
		should: [dog name: 'foo'. repository save: dog ]
		raise: VOMongoSaveConflictError.