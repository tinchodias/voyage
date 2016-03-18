visiting
visitToOneDescription: aDescription
	| element |
	element := aDescription accessor read: self object.
	
	self basicSyncronizeNeighbour: element description: aDescription.

