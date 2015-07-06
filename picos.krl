ruleset picos {
	meta {
		name "pico management"
		description <<
			managing and navigating picos
		>>
		author "Michael Angell"
		logging off
		
		sharing on
		provides children, parent, attributes
	}
	

	global {
	
		children = function() {
			ent:children;
		}
	
		parent = function() {
			ent:parent;
		}
	
		attributes = function() {
			ent:attributes.put( {'PicoName' : ent:name} );
		}
		
	}
	
	/*
	Notes:
	How to set primary name on creation?  Add to bootstrap?
	*/
	
	
	
	rule createChild {
		select when nano_manager new_cloud
		
		pre {
			childName = event:attr("name");
			childAttrs = event:attr("attributes"); //string representation of a hash, will be decoded in child
			
			myName = ent:name;
			myEci = meta:eci();
			myInfo = {"#{myName}" : myEci}.encode();
			
			newPico = pci:new_cloud(myEci);
			
			myChildren = ent:children.put({"#{childName}" : newPico});
		}
		
		{
			pci:new_ruleset(newPico, "b507199x5"); //install nano_manager on the new pico
			
			event:send({"cid":newPico}, "nano_manager", "newly_created")
				with attrs = {"parent": myInfo,
								"name": childName,
								"attributes": childAttrs
							};
		}
		
		fired {
			set ent:children myChildren;
		}
	}
	
	rule initializeChild {
		select when nano_manager newly_created
		
		pre {
			parentInfo = event:attr("parent").decode();
			name = event:attr("name");
			attrs = event:attr("attributes").decode();
		}
		
		{
			noop();
		}
		
		fired {
			set ent:parent parentInfo;
			set ent:children {};
			set ent:name name;
			set ent:attributes attrs;
		}
	}


	rule setPicoAttributes {
		select when nano_manager pico_attributes_set
		
		pre {
			newAttrs = event:attr("attributes");
		}
		
		{
			noop();
		}
		
		fired {
			set ent:attributes newAttrs;
		}
	}
	
	rule clearPicoAttributes {
		select when nano_manager pico_attributes_cleared
		
		pre {
		}
		
		{
			noop();
		}
		
		fired {
			clear ent:attributes;
		}
	}
	
	
	
	rule deleteChildren {
		select when nano_manager pico_deleted
			or nano_manager pico_parent_deleted
			foreach ent:children setting (name, eci)

		pre {
			picoDeleted = ent:name;
		}
		
		{
			event:send({"cid":eci}, "nano_manager", "pico_parent_deleted")
				with attrs = {"name": picoDeleted}
		}
	}
	
	rule delete {
		select when nano_manager pico_deleted
			or nano_manager pico_parent_deleted
		
		pre {
			picoDeleted = ent:name;
			eciDeleted = meta:eci();
			
			parentEci = ent:parent.values();
		}
	
		{
			pci:delete_cloud(eciDeleted);
			
			event:send({"cid":parentEci}, "nano_manager", "pico_child_deleted")
				with attrs = {"name": picoDeleted}
		}
		
	}
	
	rule removeChild {
		select when nano_manager pico_child_deleted
	
		pre {
			childToRemove = event:attr("name");
			
			newChildren = ent:children.delete(childToRemove);
		}
		
		{
			noop();
		}
		
		fired {
			set ent:children newChildren;
		}
	}

}