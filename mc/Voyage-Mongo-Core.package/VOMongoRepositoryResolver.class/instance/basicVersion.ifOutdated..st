private
basicVersion: anObject ifOutdated: aBlockClosure
	
	| id cachedVersion json retrievedVersion |
	id := self keyOf: anObject.
	id isNil ifTrue: [ "It is new" ^self ]. 

	cachedVersion := self cacheVersionAt: id.
	json := self basicRawSelectOne: anObject class where: (Dictionary with: '_id'-> id).

	json isNil ifTrue: [ "It was deleted" ^self ]. 

	retrievedVersion := json
		at: VOMongoSerializer fieldVersion
		ifAbsent: [ 0 ].
	cachedVersion = retrievedVersion ifFalse: [ "It is outdated" ^aBlockClosure value ]
