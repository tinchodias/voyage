private
retrieveInstanceOf: aClass json: jsonDictionary lazy: isLazy
	| id cachedVersion jsonVersion cachedObject result | 
	self debugLog: 'retrieving json ', jsonDictionary asString.
	
	id := jsonDictionary at: VOMongoJSONSerializer fieldRootId.
	cachedObject := self cacheAt: id.
	cachedVersion := self cacheVersionAt: id.
	jsonVersion := jsonDictionary at: VOMongoJSONSerializer fieldVersion ifAbsent: [ 0 ].
	result := cachedObject.
	
	(cachedObject isNil or: [ cachedVersion ~= jsonVersion ])
		ifTrue: [
			isLazy 
				ifFalse: [ 
					"Note any referenced root will be up-to-date because of the materializer"
					self debugLog: '--> eager object'.
					result ifNil: [ 
						result := (self retrieveClassOf: aClass json: jsonDictionary) basicNew.
						self cacheAt: id put: result ].
					self cacheAt: id putVersion: jsonVersion.
					self materialize: result fromJSON: jsonDictionary ]
				ifTrue: [ 
					"Note any referenced root will be up-to-date when de-proxyfied"
					"TODO: use json dictionary already retrieved"
					self debugLog: '--> lazy object'.
					result := repository lazyProxyClass
						repository: self
						objectClass: aClass
						id: (jsonDictionary at: VOMongoJSONSerializer fieldRootId) ] ]
		ifFalse: [
			(cachedObject isNotNil and: [ repository mustEnsureCurrentReferecesOnQueriesOf: aClass ]) ifTrue: [ 
				"Referenced roots may need to sync"
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
					].
		] ifFalse: [ self debugLog: '--> nothing to do' ] ].
		
	^result