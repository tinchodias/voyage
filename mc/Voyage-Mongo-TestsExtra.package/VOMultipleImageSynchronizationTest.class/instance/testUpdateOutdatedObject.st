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
	50 milliSeconds asDelay wait.
	ImageWorker 
		do: [ 
			repository := VOMongoTestResource new setUp repository.
			dog := repository selectOne: VOTestDog where: (Dictionary with: '_id' -> dogId).
			dog isNil ifFalse: [
				dog name: 'bar'. 
				repository save: dog ] ]
		within: 5 seconds 
		onTimeout: [].

	self 
		should: [ dog name: 'foo'. repository save: dog ]
		raise: VOMongoSaveConflictError.