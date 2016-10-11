persistence
syncronize: anObject

	| objectClass id json |
	resolver debugLog: 'sync a ', anObject class asString.

	anObject isTypePersistent ifFalse: [ ^anObject ].

	objectClass := anObject class.
	id := self keyOf: anObject.
	json := resolver
		basicRawSelectOne: objectClass 
		where: (Dictionary with: VOMongoJSONSerializer fieldRootId -> id).
		
	^json isEmptyOrNil 
		ifTrue: [ anObject ]
		ifFalse: [ resolver retrieveObjectOf: objectClass json: json eager: false ]