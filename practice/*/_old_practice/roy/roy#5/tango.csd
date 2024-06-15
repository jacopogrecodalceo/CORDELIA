	instr score

gkpulse	= 75*pump(16, fillarray(1, .5, 1, .25))

kforte = 1
kdebole = .35*lfh(3) 

ift init giflamenco
kft pump 8, fillarray(giflamenco, giminor3)
kch pump 8, fillarray(0, 0, 0, 0, 1, 3)

$if hex("8883", 16) $then
	eva("bois2",
	gkbeats*$once(kforte, kdebole, kdebole, kdebole, kforte, kdebole)*2,
	accent(6, $f)*$once(kforte, kdebole, kdebole, kdebole, kforte, kdebole),
	giclassic$atk(5),
	step("3D", ift, 5+pump(4, fillarray(1, 3))),
	step("3D", ift, kch+2+pump(4, fillarray(1, 3, 1, 6))),
	step("3D", ift, kch+0+pump(4, fillarray(1, 3, 1, 6))))
endif

$if hex("8883", 16) $then
	eva("noij",
	gkbeats*$once(kforte, kdebole, kdebole, kdebole, kforte, kdebole)*2,
	accent(6, $f)*$once(kforte, kdebole, kdebole, kdebole, kforte, kdebole),
	giclassic$atk(5),
	step("3D", ift, 5+pump(4, fillarray(1, 3))),
	step("3D", ift, kch+2+pump(4, fillarray(1, 3, 1, 6))),
	step("3D", ift, kch+0+pump(4, fillarray(1, 3, 1, 6))))
endif

$if hex("aaab", 64) $then
	eva("bois",
	gkbeats,
	accent(8, $pp),
	gieclassic$atk(5),
	step("4D", ift, 5+pump(32, fillarray(1, 3))),
	step("5D", ift, kch+2+pump(4, fillarray(1, 3, 1, 6))),
	step("3D", ift, kch+0+pump(4, fillarray(1, 3, 1, 6))))
endif
$if hex("aaab", 64) $then
	eva("mhon2q",
	gkbeats,
	accent(8, $pp),
	gieclassic$atk(5),
	step("4D", ift, 5+pump(32, fillarray(1, 3))),
	step("5D", ift, kch+2+pump(4, fillarray(1, 3, 1, 6))),
	step("3D", ift, kch+0+pump(4, fillarray(1, 3, 1, 6))))
endif


	endin
	start("score")

	

	instr route

getmeout("bois2")
getmeout("bois")
;convj2("noij", "bois", lfh(4)*.25)
;convj2("mhon2q", "bois", lfh(3)*.25)

	endin
	start("route")

