ruleset some_events {
	meta {
		name "Event Chains"
		description <<
			Two rules, chained with event:send.  Checking if logs will work properly
		>>
		author "Michael Angell"
		
		sharing on
		logging on
	}
	
	rule first {
		select when chains first
		
		event:send({"cid": "DBF1FF2A-A05D-11E5-9734-DFAEE71C24E1"}, "chains", "second") with
			attrs = {"something": "awesome"};
		
		fired {
			log("First event in chain logged");
		}
	}
	
	rule echo {
		select when chains second
		
		noop()
		
		fired {
			log("Second event in chain logged");
		}
	}
		
}