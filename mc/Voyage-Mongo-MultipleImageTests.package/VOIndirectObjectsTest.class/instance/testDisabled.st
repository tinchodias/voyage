tests
testDisabled

	| dog |
	repository
		ensuringCurrentReferencesOnQueries: false.

	dog := self dogAfterExternalUpdate.

	self assert: dog owner class equals: VOTestOwner.
	self assert: dog owner name equals: 'foo'.