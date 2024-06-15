	instr score

gkpulse = 120-(pump(12, fillarray(0, 90, 0, 0))*cosseg(1, 75, 0))

$when(eujo(3, 8, 8))
	eva("grind",
	gkbeats*$once(1, 1, 1, 1, 3)*$once(1, 2),
	accent(3, $ppp),
	giclassic,
	step("5F", giquarter, 12+$once(1, 3, 5, 7, 3, 1, 3, 9, 10)))
endif

kdyn cosseg 0, 65, 1
kvar pump 12, fillarray(24, 16, 24, 24, 32)

$when(eujo(8, 8, kvar))
	eva(oncegen(girot6), "repuck",
	gkbeats*$once(1, 1, 1, 1, 12),
	accent(3, $f)*kdyn,
	gilikearev$atk(5),
	step("3F", giquarter, pump(8, fillarray(1, 3, 5, 7, 3, 1, 3, 9, 10)))*$once(1, .25, .5, 1),
	step("3F", giquarter, pump(8, fillarray(1, 3, 5, 7, 3, 1, 3, 9, 10)))*$once(.25, .5, 1))
endif


kshin lfh 1
shinobi(kvar/3, $f*kshin)

	endin
	start("score")


	
	instr ruote

getmeout("grind")
getmeout("repuck")
convj2("shinobi", "grind")
getmeout("shinobi", lfa(1, 1/35)*1/24)
	endin
	start("ruote")



