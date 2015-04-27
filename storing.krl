ruleset song_store {
	meta {
		name "storing"
		description <<
			Stores songs sung
		>>
		author "Michael Angell"
		logging on
		sharing on
		provides songs, hymns, secular_music

	}
	
	global {
		songs = function() {
			ent:songs
		}
		
		hymns = function() {
			ent:hymns
		}
		
		secular_music = function() {
			ent:songs.values().difference(ent:hymns.values())
		}
	}

	
	rule collect_songs {
		select when explicit sung
		
		pre {
			m = event:attr("song");
		}
		
		{ noop(); }
		
		fired {
			set ent:songs ent:songs.put(time:new(), m);
		}
	}

	rule collect_hymns {
		select when explicit found_hymn
		
		pre {
			m = event:attr("song");
		}
		
		{ noop(); }
		
		fired {
			set ent:hymns ent:hymns.put(time:new(), m);
		}
	}

	rule clear_songs {
		select when song reset
		
		{ noop(); }
		
		fired {
			set ent:songs {};
			set ent:hymns {};
		}
	}

}