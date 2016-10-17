tests
dogAfterExternalUpdateWith: dogClass

	| dog owner dogId |
	"create dog with owner named foo"
	dog := dogClass new name: 'cometa'; yourself.
	owner := 
		VOTestOwner new 
			name: 'foo'; 
			addPet: dog;
			yourself.
	repository save: owner.
	dogId := repository idOf: dog.

	"check owner name is foo"
	self waitForWriteOperation.
	"dog := repository selectOne: VOTestDog where: (Dictionary with: VOMongoJSONSerializer fieldRootId -> dogId).
	self assert: dog owner name equals: 'foo'."
	
	"FORKED IMAGE: change owner name to bar"
	ImageWorker 
		do: [ 
			(repository selectAll: VOTestOwner) 
				do: [ :each | each name: 'bar'. repository save: each ] ]
		within: 5 seconds 
		onTimeout: [].

	"check owner name is foo (i.e. not current)"
	self waitForWriteOperation.
	self forkImageAndDo: [ 
		(repository selectAll: VOTestOwner) 
			do: [ :each | each name: 'bar'. repository save: each ] ].
	
	'* select dog whose owner externally changed it''s name *' logCr.
	self waitForWriteOperation.
	^ repository 
		selectOne: dogClass 
		where: (Dictionary with: VOMongoJSONSerializer fieldRootId -> dogId).
