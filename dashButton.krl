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
			mac = event:attr("mac").defaultsTo("", "no mac address passed for registration").klog("mac made");
			target = event:attr("target").defaultsTo("", "no target for registration").klog("target made");
			domain = event:attr("domain").defaultsTo("", "no domain for registration").klog("domain made");
			event_type = event:attr("event_type").defaultsTo("", "no type for registration").klog("type made");
			
			newRegistration = {
				"target" : target,
				"domain" : domain,
				"type" : event_type
			}
		}
		if (not (mac eq "" || target eq "" || domain eq "" || event_type eq "")) then
		{
			send_directive("attempted registration") with body = "hope it worked";
		}
		fired {
			//clear ent:unregistered{mac};
			//set ent:registered{mac} newRegistration;
			log ("registration happened, maybe something happened?");
		}
	}
  
	rule handleButtonPress {
		select when dash_button button_pressed
		pre {
			mac = event:attr("mac").defaultsTo("", "no mac address passed");
			
			target = ent:registered{[mac, "target"]};
			domain = ent:registered{[mac, "domain"]};
			type = ent:registered{[mac, "type"]};
		}
		
		if (mac neq "" && ent:registered >< mac) then {
			event:send({"cid":target}, domain, type)
				with attrs = {"mac": map}
		}
		
    	fired {
			log ("registered button pressed on #{mac}");
    	} else {
			log ("unregistered button pressed on #{mac}");
		}
	}
}