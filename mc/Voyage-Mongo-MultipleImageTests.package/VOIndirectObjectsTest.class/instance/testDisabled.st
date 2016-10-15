tests
testDisabled

	| dog |
	repository
		debug: true;
		ensuringCurrentOnQueries: false.

	dog := self dogAfterExternalUpdate.

	self assert: dog owner class equals: VOTestOwner.
	self assert: dog owner name equals: 'foo'.