giREAPER_PORT init 8000

		instr reamur

OSCsend 1, "localhost", giREAPER_PORT, "t/region", "i", p4
OSCsend 1, "localhost", giREAPER_PORT, "t/play", "i", 1
		turnoff
		endin
