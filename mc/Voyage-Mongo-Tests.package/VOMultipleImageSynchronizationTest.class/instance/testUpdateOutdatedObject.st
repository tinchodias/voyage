tests
testUpdateOutdatedObject
	| dog |

	"set up scenario"
	dog := VOTestDog new name: 'carola'; yourself.
	self repository save: dog.
	
	"FORKED IMAGE: change dog name to bar"
	ImageWorker 
		do: [ 
			dog name: 'bar'. self repository save: dog ]
		within: 5 seconds 
		onTimeout: [].
	50 milliSeconds asDelay wait.

	self 
		should: [dog name: 'foo'. self repository save: dog ]
		raise: VOMongoSaveConflictError.