tests
testUpdateOutdatedObject
	| dog dogId |
	
	"set up scenario"
	dog := VOTestDog new name: 'carola'; yourself.
	self repository save: dog.
	dogId := self repository idOf: dog.

	"FORKED IMAGE: change dog name to bar"
	ImageWorker 
		do: [ 
			| repository |
			repository := VOMongoTestResource new setUp repository.
			dog := repository selectOne: VOTestDog where: (Dictionary with: '_id' -> dogId).
			self deny: dog isNil.
			dog name: 'bar'. 
			repository save: dog ].

	"The locally updated dog is outdated respect to the db"
	self 
		should: [ dog name: 'foo'. self repository save: dog ]
		raise: VOMongoSaveConflictError.