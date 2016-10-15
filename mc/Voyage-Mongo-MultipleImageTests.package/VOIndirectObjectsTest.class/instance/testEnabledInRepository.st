tests
testEnabledInRepository

	| dog |
	repository
		debug: true;
		ensuringCurrentReferencesOnQueries: true.
	
	dog := self dogAfterExternalUpdate.

	self assert: dog owner class equals: VOMongoLazyProxy.
	self assert: dog owner name equals: 'bar'.
	self assert: dog owner class equals: VOTestOwner.
