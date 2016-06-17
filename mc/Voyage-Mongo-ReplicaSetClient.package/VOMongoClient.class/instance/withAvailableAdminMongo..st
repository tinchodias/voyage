accessing
withAvailableAdminMongo: aBlockClosure
	"Iterate ad-infinitum over member mongos"

	self flag: #todo. "too much tolarance"
	
	[ cachedAdminByMember valuesDo: [ :each |
		each isAvailable ifTrue: [ 
			[ ^ aBlockClosure value: each ]
				on: NetworkError, PrimitiveFailed 
				do: [:error | 
					"Unavailable member => skip"
					self debugLog: error ]
		]].

		self debugLog: 'no available member'.
		"Wait a bit before restarting loop"
		3 seconds wait. 
	
	true ] whileTrue 