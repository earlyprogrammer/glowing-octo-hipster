ruleset picos {
	meta {
		name "pico testing"
		description <<
			managing and navigating picos
		>>
		author "Michael Angell"
		logging off
		
		sharing on
		provides newChild, deletePico, listChildren, listParent, setParent
	}
	

	global {
		
		newChild = function() {
			eci = meta:eci();
			newPico = pci:new_cloud(eci);
			newEci = newPico['cid'];
			
			rsi = pci:new_ruleset(meta:rid());
			{
				'childEci' : newEci
			}
		}
		
		deletePico = function(cascade) {
			eci = meta:eci();
			pci:delete_cloud(eci, {"cascade" : cascade});
		}
		
		listChildren = function() {
			eci = meta:eci();
			children = pci:list_children(eci);
			{
				'children' : children
			}
		}
		
		listParent = function() {
			eci = meta:eci();
			parent = pci:list_parent(eci);
			{
				'parent' : parent
			}
		}
		
		setParent = function(newParent) {
			child = meta:eci();
			target = pci:set_parent(child, newParent);
			{
				'newParent' : target
			}
		}
	}

}