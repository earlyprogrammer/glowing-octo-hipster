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
			ent:unregistered;
		}
		
		registrations = function() {
			ent:registered;
		}
	}
	
	rule registerButton {
		select when dash_button registration
		pre {
			mac = event:attr("mac").defaultsTo("", "no mac address passed for registration");
			target = event:attr("target").defaultsTo("", "no target for registration");
			domain = event:attr("domain").defaultsTo("", "no domain for registration");
			type = event:attr("type").defaultsTo("", "no type for registration");
			
			newRegistration = {
				"target" : target,
				"domain" : domain,
				"type" : type
			}
		}
		if (not (mac=="" || target=="" || domain=="" || type=="")) then
		{
			noop();
		}
		fired {
			clear ent:unregistered{mac};
			set ent:registered{mac} newRegistration;
		}
	}
  
	rule handleButtonPress {
		select when dash_button button_pressed
		pre {
			mac = event:attr("mac").defaultsTo("", "no mac address passed");
			
			
		}
		{
			noop();
		}
    	always{
			log ("button pressed on #{mac}");
    	}
	}
}