serializing
synchronize: anObject
	^self 
		synchronize: anObject 
		description: (self descriptionFor: anObject)
	