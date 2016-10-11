persistence
syncronize: anObject

	| objectClass id json |
	anObject isTypePersistent ifFalse: [ ^anObject ].
	
	objectClass := anObject class.
	id := self keyOf: anObject.
	json := resolver
		basicRawSelectOne: objectClass 
		where: (Dictionary with: VOMongoJSONSerializer fieldRootId -> id).
		
	^json isEmptyOrNil 
		ifTrue: [ anObject ]
		ifFalse: [ resolver retrieveObjectOf: objectClass json: json eager: true ]