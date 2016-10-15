tests
testDisabled

	| dog |
	repository
		debug: true;
		ensuringCurrentReferencesOnQueries: false.

	dog := self dogAfterExternalUpdate.

	self assert: dog owner class equals: VOTestOwner.
	self assert: dog owner name equals: 'foo'.