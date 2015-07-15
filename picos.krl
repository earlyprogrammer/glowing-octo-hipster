ruleset picos {
	meta {
		name "pico testing"
		description <<
			managing and navigating picos
		>>
		author "Michael Angell"
		logging off
		
		sharing on
		provides newPico, deletePico, listChildren, listParent, setParent
	}
	

	global {
	
		newPico = function(eci) {
			newEci = pci:new_cloud(eci);
			{ 
				'status' : "good",
				'newEci' : newEci
			}
		}
		
		deletePico = function(eci, cascade) {
			pci:delete_cloud(eci, {"cascade" : cascade});
		}
		
		listChildren = function(eci) {
			//{'status' : "elmo"};
			pci:list_children(eci);
		}
		
		listParent = function(eci) {
			pci:list_parent(eci);
		}
		
		setParent = function(child, newParent) {
			pci:set_parent(child, newParent);
		}
	}

}