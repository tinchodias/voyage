tests
testEnabledInRepository: isLazySynchronize

	| dog |
	repository
		ensuringCurrentReferencesOnQueries: true;
		lazySynchronize: isLazySynchronize.
	
	dog := self dogAfterExternalUpdate.

	self assert: dog owner class equals: VOMongoLazyProxy.
	self assert: dog owner name equals: 'bar'.
	self assert: dog owner class equals: VOTestOwner.
