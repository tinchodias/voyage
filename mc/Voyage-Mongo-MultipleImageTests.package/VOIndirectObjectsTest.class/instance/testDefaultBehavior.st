tests
testDefaultBehavior

	| dog owner dogId |
	"set up scenario"
	dog := VOTestDog new name: 'cometa'; yourself.
	owner := 
		VOTestOwner new 
			name: 'foo'; 
			addPet: dog;
			yourself.
	repository save: owner.
	dogId := repository idOf: dog.

	"check owner name is foo"
	self waitForWriteOperation.
	dog := repository selectOne: VOTestDog where: (Dictionary with: '_id' -> dogId).
	self assert: dog owner name equals: 'foo'.
	
	"FORKED IMAGE: change owner name to bar"
	ImageWorker 
		do: [ 
			(repository selectAll: VOTestOwner) 
				do: [ :each | each name: 'bar'. repository save: each ] ]
		within: 5 seconds 
		onTimeout: [].

	"check owner name is foo (i.e. not current)"
	self waitForWriteOperation.
	dog := repository selectOne: VOTestDog where: (Dictionary with: '_id' -> dogId).
	self assert: dog owner name equals: 'foo'.

	"SYNCHRONIZE"
	"(VOMongoNeighbourSynchronizer repository: repository) synchronize: dog.
	self assert: dog owner name equals: 'bar'."