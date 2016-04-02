private
basicSyncronizeNeighbour: anObject description: aDescription 
	
	anObject isTypePersistent ifFalse: [ ^self ].

	self flag: #todo. "	If object is not in cache, create a proxy with this results: 
	repository
		basicRawSelectOne: anObject class 
		where: (Dictionary with: '_id'->(self keyOf: anObject))."	
	
	repository
		selectOne: anObject class 
		where: (Dictionary with: '_id'->(self keyOf: anObject)).
		
	self synchronize: anObject.