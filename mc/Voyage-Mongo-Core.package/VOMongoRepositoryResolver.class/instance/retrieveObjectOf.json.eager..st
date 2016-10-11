private
retrieveObjectOf: aClass json: aDictionary eager: isEager
	| id cachedVersion retrievedVersion object | 
	self debugLog: 'retrieve ', aDictionary asString.
	
	id := aDictionary at: VOMongoJSONSerializer fieldRootId.
	object := self cacheAt: id.
	cachedVersion := self cacheVersionAt: id.
	retrievedVersion := aDictionary 
		at: VOMongoJSONSerializer fieldVersion
		ifAbsent: [ 0 ].
	(object isNil or: [ cachedVersion ~= retrievedVersion ])
		ifTrue: [
			isEager 
				ifTrue: [ 
					object ifNil: [ 
						object := (self retrieveClassOf: aClass json: aDictionary) basicNew.
						self cacheAt: id put: object ].
					self cacheAt: id putVersion: retrievedVersion.
					self materialize: object fromJSON: aDictionary ]
				ifFalse: [ 
					"TODO: use json dictionary already retrieved"
					repository lazyProxyClass
						repository: self
						objectClass: aClass
						id: (aDictionary at: VOMongoJSONSerializer fieldRootId) ] ]
		ifFalse: [
			(object isNotNil and: [ repository isEnsuringCurrentOnQueries ]) ifTrue: [ 
				"Referenced roots may need sync"
				| roots |
				roots := VOCollector allRootsFrom: object in: repository.
				(roots copyWithout: object) do: [ :root | repository syncronize: root ]
		]].
		
	^object