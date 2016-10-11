tests
testEnabled

	| dog |
	repository
		debug: true;
		ensuringCurrentOnQueries: true.
	
	dog := self dogAfterExternalUpdate.

	"1halt." "WHY IT IS NOT PROXY?"

	self assert: dog owner class equals: VOMongoLazyProxy.
	self assert: dog owner name equals: 'bar'.