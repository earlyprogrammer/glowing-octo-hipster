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
			event_domain = event:attr("event_domain").defaultsTo("", "no domain for registration");
			event_type = event:attr("event_type").defaultsTo("", "no type for registration");
			
			newRegistration = {
				"target" : target,
				"event_domain" : event_domain,
				"event_type" : event_type
			}
		}
		if (not (mac eq "" || target eq "" || event_domain eq "" || event_type eq "")) then
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
			mac = event:attr("mac").defaultsTo("", "no mac address passed").klog();
			
			target = ent:registered{[mac, "target"]}.klog();
			event_domain = ent:registered{[mac, "event_domain"]}.klog();
			event_type = ent:registered{[mac, "event_type"]}.klog();
			
			target_map = {"cid" : target}.klog();
		}
		
		if (mac neq "" && ent:registered >< mac) then {
			event:send(target_map, event_domain, event_type) with
				attrs = {"mac": mac};
		}
		
    	fired {
			log ("registered button pressed on #{mac}");
    	} else {
			log ("unregistered button pressed on #{mac}");
			set ent:unregistered{mac} time:now();
		}
	}
}