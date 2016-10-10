visiting
visitToManyDescription: aDescription
	| elements |
	elements := aDescription accessor read: self object.
	
	elements ifNil: [ ^self ].

	elements do: [ :element | self basicSyncronizeNeighbour: element description: aDescription ].
