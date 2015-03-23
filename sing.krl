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
		select when echo message input "(.*)" setting(m)
		send_directive("sing") with
			song = m;
	}
}