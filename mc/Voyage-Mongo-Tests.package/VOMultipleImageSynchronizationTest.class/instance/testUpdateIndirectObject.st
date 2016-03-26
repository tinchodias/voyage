tests
testUpdateIndirectObject
	| dog owner dogId repository |
	
	"clean up"
	repository := VOMongoTestResource new setUp repository.
	repository dropDatabase.

	"set up scenario"
	50 milliSeconds asDelay wait.
	repository := VOMongoTestResource new setUp repository.
	dog := VOTestDog new name: 'carola'; yourself.
	owner := 
		VOTestOwner new 
			name: 'foo'; 
			addPet: dog;
			yourself.
	repository save: owner.
	dogId := repository idOf: dog.

	"check owner name is foo"
	50 milliSeconds asDelay wait.
	dog := repository selectOne: VOTestDog where: (Dictionary with: '_id' -> dogId).
	self assert: dog owner name equals: 'foo'.
	
	"FORKED IMAGE: change owner name to bar"
	ImageWorker 
		do: [ 
			repository := VOMongoTestResource new setUp repository.
			(repository selectAll: VOTestOwner) 
				do: [ :each | each name: 'bar'. repository save: each ] ]
		within: 5 seconds 
		onTimeout: [].
	50 milliSeconds asDelay wait.

	"check owner name is bar"
	dog := repository selectOne: VOTestDog where: (Dictionary with: '_id' -> dogId).
	self assert: dog owner name equals: 'foo'.

	"SYNCHRONIZE"
	repository synchronize: dog.
	self assert: dog owner name equals: 'bar'.
	