tests
testUpdateOutdatedObject
	| dog dogId repository |
	
	"set up scenario"
	repository := VOMongoTestResource new setUp repository.
	dog := VOTestDog new name: 'carola'; yourself.
	repository save: dog.
	dogId := repository idOf: dog.

	"FORKED IMAGE: change dog name to bar"
	ImageWorker 
		do: [ 
			repository := VOMongoTestResource new setUp repository.
			dog := repository selectOne: VOTestDog where: (Dictionary with: '_id' -> dogId).
			self deny: dog isNil.
			dog name: 'bar'. 
			repository save: dog ].

	"The locally updated dog is outdated respect to the db"
	self 
		should: [ dog name: 'foo'. repository save: dog ]
		raise: VOMongoSaveConflictError.