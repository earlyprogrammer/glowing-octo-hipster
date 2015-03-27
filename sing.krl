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
			song = m;
	}
}