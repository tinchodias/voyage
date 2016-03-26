tests
testUpdateOutdatedObject
	| dog dogId repository |
	
	"ensure clean"
	repository := VOMongoTestResource new setUp repository.
	repository dropDatabase.

	"set up scenario"
	50 milliSeconds asDelay wait.
	repository := VOMongoTestResource new setUp repository.
	dog := VOTestDog new name: 'carola'; yourself.
	repository save: dog.
	dogId := repository idOf: dog.

	"FORKED IMAGE: change dog name to bar"
	ImageWorker 
		do: [ 
			repository := VOMongoTestResource new setUp repository.
			dog := repository selectOne: VOTestDog where: (Dictionary with: '_id' -> dogId).
			self assert: dog isNotNil.
			dog name: 'bar'. 
			repository save: dog. ]
		within: 5 seconds 
		onTimeout: [].
	5.3 seconds asDelay wait.

	self 
		should: [ dog name: 'foo'. repository save: dog ]
		raise: VOMongoSaveConflictError.