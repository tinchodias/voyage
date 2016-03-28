tests
tearDown
	"Reset the DB after each test"
	
	VOMongoTestResource current repository 
		removeAll: VOTestPet;
		removeAll: VOTestPilot.
	100 milliseconds asDelay wait. "Wait to avoid concurrency conflicts"