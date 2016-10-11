tests
testDisabled

	repository
		debug: true;
		ensuringCurrentOnQueries: false.
	
	self assert: self dogAfterExternalUpdate owner name equals: 'foo'.