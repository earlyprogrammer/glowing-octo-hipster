ruleset echo {
	meta {
		name "echo"
		description <<
			An echo endpoint
		>>
		author "Michael Angell"
		logging on
	}
	
	rule hello_world is active {
		select when echo hello
		send_directive("say") with
			something = "Hello World";
	}
	
	rule echo is active {
		select when echo message input "(.*)" setting(m)
		send_directive("say") with
			something = m;
	}
		
}