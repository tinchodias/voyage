tests
testEnabledInClassWithLazySynchronize

	repository
		ensuringCurrentReferencesOnQueries: true;
		lazySynchronize: true.
	
	self setUpDogWithOutdatedReferenceOf: VOTestDogEnsuringCurrentReferencesOnQueries.

	self assert: dog owner class equals: VOMongoLazyProxy.
	self assert: dog owner name equals: 'bar'.
	self assert: dog owner class equals: VOTestOwner.
