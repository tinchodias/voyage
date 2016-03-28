running
tearDown
	"Reset the DB after each test"
	
	self repository 
		removeAll: VOTestPet;
		removeAll: VOTestPilot.
	500 milliseconds asDelay wait. "Wait to avoid concurrency conflicts"