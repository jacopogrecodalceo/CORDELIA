	instr score

gkpulse	= 60

$when(hex("9214", 16))
	eva("burd",
	gkbeats*$once(1, 1, .5, .5, .5),
	accent(3, $f),
	$once(gieclassic, gieclassic),
	ntof("3F#"))
endif

$when(hex("9214", 17))
	eva("burd",
	gkbeats*$once(1, 1, .5, .5, .5),
	accent(3, $f),
	$once(gieclassic, gieclassic),
	ntof("4E"),
	ntof("3A"),
	ntof("3D"))
endif

$when(hex("8", 16))
	eva("bass",
	gkbeats,
	$fff,
	$once(gieclassic, giclassic)$atk(1),
	ntof("0B"))
endif

	endin
	start("score")

	
	instr route

getmeout("burd")
getmeout("bass")
	endin
	start("route")

