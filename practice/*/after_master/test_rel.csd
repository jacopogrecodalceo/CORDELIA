	instr score

gkpulse	= 90

$if eu(3, 8, 32, "heart") $then
	eva("repuck", 
	gkbeats*8,
	accent(5, $f),
	$once(gired, gigrembo)$atk(5),
	fc("4B", gired, "6E", 1)*$once(.25, 1, .5, 1, 1),
	fc("4B", gigrembo, "4E", 1)*$once(1, .25, 1, 2, 1))
endif

	endin
	start("score")

	
	instr route

irel		init 1
			xtratim 1
krel		init 0
krel		release

if krel == 1 then
	getmeoutr("repuck")
endif

	getmeout("repuck")


	endin
	start("route")

