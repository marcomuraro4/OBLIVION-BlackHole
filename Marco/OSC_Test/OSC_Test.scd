(

NetAddr("127.0.0.1", 57121);

OSCdef('OSCinit',
	{ arg msg;
		postln("Connection established: " + msg[1]);
	},
	"/OSCinit");

OSCdef('OSCreceiver',
	{ arg msg;
		postln("New message: " + msg[1] + msg[2]);
	},
	"/mass");

)

