private retrieving
synchronizeInstanceOf: aClass json: jsonDictionary updating: cachedObject

	(cachedObject isNotNil and: [ repository mustEnsureCurrentReferecesOnQueriesOf: aClass ]) 
		ifTrue: [ 
			"Cached object itself is up-to-date, but referenced roots may need to sync"
			| roots syncRoots |
			self debugLog: '--> looking for outdated referenced objects'.
			roots := VOCollector allOtherRootsFrom: cachedObject in: repository.
			roots := roots asArray.
			syncRoots := roots collect: [ :root | repository syncronize: root ].
			syncRoots ifNotEmpty: [
				self debugLog: '----> becoming ', (roots collect: [:each | each class asString]) asString.
				repository flushCache.
				roots elementsForwardIdentityTo: syncRoots copyHash: false.
				self debugLog: '----> became into ', (roots collect: [:each | each class asString]) asString.		
				]] 
		ifFalse: [ self debugLog: '--> nothing to do' ]