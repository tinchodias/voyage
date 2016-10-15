private retrieving
proxyfyInstanceOf: aClass json: jsonDictionary id: id

	"Note any referenced root will be up-to-date when de-proxyfied"
	"TODO: use json dictionary already retrieved"
	self debugLog: '--> lazy object'.
	^ repository lazyProxyClass
		repository: self
		objectClass: aClass
		id: id