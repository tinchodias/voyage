tests
testNetworkError
	self
		should: [ VOMongoRepository host: '999.999.999.999' database: 'Voyage-Tests' ]
		raise: Error