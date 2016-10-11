visiting
visitToOneDescription: aDescription
	| element |
	element := aDescription accessor read: self object.

	element ifNil: [ ^self ].
	
	self value: element

