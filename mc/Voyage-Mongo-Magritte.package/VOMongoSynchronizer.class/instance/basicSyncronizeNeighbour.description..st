private
basicSyncronizeNeighbour: anObject description: aDescription 
	
	anObject isTypePersistent ifFalse: [ ^self ].
	
	repository
		selectOne: anObject class 
		where: (Dictionary with: '_id'->(self keyOf: anObject)).
		
	self synchronize: anObject.