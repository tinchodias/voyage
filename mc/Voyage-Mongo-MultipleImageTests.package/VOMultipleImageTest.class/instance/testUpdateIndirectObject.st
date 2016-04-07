tests
testUpdateIndirectObject
	| dog owner dogId |
	"set up scenario"
	dog := VOTestDog new name: 'carola'; yourself.
	owner := 
		VOTestOwner new 
			name: 'foo'; 
			addPet: dog;
			yourself.
	self repository save: owner.
	dogId := self repository idOf: dog.

	"check owner name is foo"
	50 milliSeconds asDelay wait.
	dog := self repository selectOne: VOTestDog where: (Dictionary with: '_id' -> dogId).
	self assert: dog owner name equals: 'foo'.
	
	"FORKED IMAGE: change owner name to bar"
	ImageWorker 
		do: [ 
			(self repository selectAll: VOTestOwner) 
				do: [ :each | each name: 'bar'. self repository save: each ] ]
		within: 5 seconds 
		onTimeout: [].

	"check owner name is foo (i.e. not current)"
	50 milliSeconds asDelay wait.
	dog := self repository selectOne: VOTestDog where: (Dictionary with: '_id' -> dogId).
	self assert: dog owner name equals: 'foo'.

	"SYNCHRONIZE"
	(VOMongoNeighbourSynchronizer repository: self repository) synchronize: dog.
	self assert: dog owner name equals: 'bar'.
	