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
			a = (ent:songs) => ent:songs | {};
			a = a.put([time:new()], m);
		}
		
		{ noop(); }
		
		fired {
			set ent:songs a;
		}
	}

	rule collect_hymns {
		select when explicit found_hymn
		
		pre {
			m = event:attr("song");
			a = (ent:hymns) => ent:hymns | {};
			a = a.put([time:new()], m);
		}
		
		{ noop(); }
		
		fired {
			set ent:hymns a;
		}
	}

	rule clear_songs {
		select when song reset
		
		{ noop(); }
		
		fired {
			clear ent:songs;
			clear ent:hymns;
		}
	}

}