private
retrieveObjectOf: aClass json: aDictionary eager: isEager
	| id cachedVersion retrievedVersion object | 
	self debugLog: 'retrieving json ', aDictionary asString.
	
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
					self debugLog: '--> eager object'.
					object ifNil: [ 
						object := (self retrieveClassOf: aClass json: aDictionary) basicNew.
						self cacheAt: id put: object ].
					self cacheAt: id putVersion: retrievedVersion.
					self materialize: object fromJSON: aDictionary ]
				ifFalse: [ 
					"TODO: use json dictionary already retrieved"
					self debugLog: '--> lazy object'.
					object := repository lazyProxyClass
						repository: self
						objectClass: aClass
						id: (aDictionary at: VOMongoJSONSerializer fieldRootId) ] ]
		ifFalse: [
			(object isNotNil and: [ repository isEnsuringCurrentOnQueries ]) ifTrue: [ 
				"Referenced roots may need to sync"
				| roots syncRoots |
				self debugLog: '--> looking for outdated referenced objects'.
				roots := VOCollector allRootsFrom: object in: repository.
				roots := roots asArray reject: [ :each | each == object].
				syncRoots := roots collect: [ :root | repository syncronize: root ].
				syncRoots ifNotEmpty: [
					self debugLog: '----> becoming ', (roots collect: [:each | each class asString]) asString.
					repository flushCache.
					roots elementsForwardIdentityTo: syncRoots copyHash: false.
					self debugLog: '----> became into ', (roots collect: [:each | each class asString]) asString.
					"roots withIndexDo: [ :each :index |
						| other |
						other := (syncRoots at: index).
						each ~~ other ifTrue: [
							self debugLog: '--> become a ', each class asString, ' into a ', other class asString.
							each becomeForward: other] ]."					
					].
		] ifFalse: [ self debugLog: '--> nothing to do' ] ].
		
	^object