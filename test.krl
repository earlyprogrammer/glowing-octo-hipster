ruleset picos {
	meta {
		name "testing file for anything"
		description <<
			I will do awesome things with this ruleset
		>>
		author "Michael Angell"
		
		provides justEmptyArray, emptyArrayDefaults, justDefaults
		
		
		logging on
		
		sharing on
	}
	
	global {
	
		justEmptyArray = function(){
			a = [];
			a;
		}
	
		emptyArrayDefaults = function(){
			a = [];
			b = a.defaultsTo(["defaults triggered on empty array"]);
			b;
		}
		
		justDefaults = function(){
			a = x.defaultsTo(["defaults triggered on undefined"]);
			a;
		}
	}

	rule simpleEndpoint {
		select when buttonPushTester pushed
		pre {
			something = event:attr("attr");
		}
		{
			noop();
		}
		always {
			log ("button pressed, received attribute #{something}");
		}
	}

}