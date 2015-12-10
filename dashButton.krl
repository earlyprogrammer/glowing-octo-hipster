ruleset DashButton {
	meta {
		name "DashButton"
		description <<
			Receive and relay DashButton events
		>>
		author "Michael Angell"
		logging on
		sharing on

		provides unregisteredClicks, registrations
	}
  
	global {
		unregisteredClicks = function() {
			{
				"unexpected buttons" : ent:unregistered
			};
		}
		
		registrations = function() {
			{
				"registered buttons" : ent:registered
			};
		}
	}
	
	rule registerButton {
		select when dash_button registration
		pre {
			mac = event:attr("mac").defaultsTo("", "no mac address passed for registration");
			target = event:attr("target").defaultsTo("", "no target for registration");
			domain = event:attr("domain").defaultsTo("", "no domain for registration");
			event_type = event:attr("event_type").defaultsTo("", "no type for registration");
			
			newRegistration = {
				"target" : target,
				"domain" : domain,
				"event_type" : event_type
			}
		}
		if (not (mac eq "" || target eq "" || domain eq "" || event_type eq "")) then
		{
			noop();
		}
		fired {
			clear ent:unregistered{mac};
			set ent:registered{mac} newRegistration;
			log ("registered relay for #{mac}");
		}
	}
  
	rule handleButtonPress {
		select when dash_button button_pressed
		pre {
			mac = event:attr("mac").defaultsTo("", "no mac address passed");
			
			target = ent:registered{[mac, "target"]};
			domain = ent:registered{[mac, "domain"]};
			event_type = ent:registered{[mac, "event_type"]};
		}
		
		if (mac neq "" && ent:registered >< mac) then {
			event:send({"cid":target}, domain, event_type)
				with attrs = {"mac": map}
		}
		
    	fired {
			log ("registered button pressed on #{mac}");
    	} else {
			log ("unregistered button pressed on #{mac}");
			set ent:unregistered{mac} time:now();
		}
	}
}