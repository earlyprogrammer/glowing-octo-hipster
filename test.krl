ruleset picos {
	meta {
		name "pico management"
		description <<
			managing and navigating picos
		>>
		author "Michael Angell"
		logging off
		
		sharing on
	}
	


	rule createChild {
		select when purple elephant
		
		pre {
			a = function(r) {
				r+1;
			}
		}
		
		{
			send_directive("answer") with body = a(2);
		}
	}
	

}