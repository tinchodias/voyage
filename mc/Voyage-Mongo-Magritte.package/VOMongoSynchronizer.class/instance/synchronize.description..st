serializing
synchronize: anObject description: aDescription
	| oldObject |
	oldObject := self object.
	[ 
	  self object: anObject.
	  self visit: aDescription ]
	ensure: [ 
		self object: oldObject ].
