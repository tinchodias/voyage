private retrieving
proxyfyInstanceOf: aClass json: jsonDictionary id: id

	"Note any referenced root will be up-to-date when de-proxyfied"
	self flag: #todo. "use json dictionary already retrieved"
	^ repository lazyProxyClass
		repository: self
		objectClass: aClass
		id: id