tests
testEnabledInClass

	| dog |
	repository
		debug: true;
		ensuringCurrentReferencesOnQueries: false.
	
	dog := self dogAfterExternalUpdateWith: VOTestDogEnsuringCurrentReferencesOnQueries.

	self assert: dog owner class equals: VOMongoLazyProxy.
	self assert: dog owner name equals: 'bar'.
	self assert: dog owner class equals: VOTestOwner.
