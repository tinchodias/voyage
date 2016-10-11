tests
testEnabled

	repository
		debug: true;
		ensuringCurrentOnQueries: true.

	self assert: self dogAfterExternalUpdate owner name equals: 'bar'.