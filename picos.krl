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
			newEci = pci:new_pico(eci);
			{ 
				'newEci' : newEci
			}
		}
		
		deletePico = function(eci, cascade) {
			pci:delete_cloud(eci, {"cascade" : cascade});
		}
		
		listChildren = function(eci) {
			children = pci:list_children(eci);
			{
				'children' : children
			}
		}
		
		listParent = function(eci) {
			parent = pci:list_parent(eci);
			{
				'parent' : parent
			}
		}
		
		setParent = function(child, newParent) {
			target = pci:set_parent(child, newParent);
			{
				'newParent' : target
			}
		}
	}

}