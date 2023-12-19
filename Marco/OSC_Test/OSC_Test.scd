(

NetAddr("127.0.0.1", 57120);

OSCdef('OSCreceiver',
	{ arg msg;
		postln("New message: " + msg[1]);
	},
	"/OSCTest");

)