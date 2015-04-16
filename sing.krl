ruleset see_songs {
	meta {
		name "singing"
		description <<
			Sing an echo
		>>
		author "Michael Angell"
		logging on
	}
	
	rule songs is active {
		select when echo message
								input "(.*)"
								msg_type "song"
							setting(m)
		
		send_directive("sing") with
			song = m
		
		fired {
			raise explicit event sung with
				song = m
		}
	}
	
	rule find_hymn {
		select when explicit sung
			pre {
				m = event:attr("song");
			}
	
		fired {
			raise explicit event found_hymn
		}
	}
}