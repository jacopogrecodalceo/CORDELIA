	instr score

gkpulse = 70+lfo(35, .15)

gkmo_topsum = gkmo_top1 + gkmo_top2 + gkmo_top3 + gkmo_top4 + gkmo_top5 + gkmo_top6 + gkmo_top7 + gkmo_top8

gkorphans3_vib = 25-portk((limit(gkmo_topsum, 0, 1)*gkbeats*8), 95$ms)

if gkroy_top1 == 1 then
	$when(eujo(3, 8, 16))
		eva("orphans3",
		gkbeats*$once(6, 1),
		accent(5, $f),
		$once(gilikearev$atk(5), giclassicr),
		step("2F", gikal, 1))
	endif
	arm1(4, $mf)

	gkroy_top1 = 0
endif

if gkroy_top2 == 1 then
	$when(eujo(3, 8, 16))
		eva("orphans3",
		gkbeats*$once(6, 1),
		accent(5, $f),
		$once(gilikearev$atk(5), giclassicr),
		step("2F", gikal, 2))
	endif
	arm1(4, $mf)

	gkroy_top2 = 0
endif

if gkroy_top3 == 1 then
	$when(eujo(3, 8, 16))
		eva("orphans3",
		gkbeats*$once(6, 1),
		accent(5, $f),
		$once(gilikearev$atk(5), giclassicr),
		step("2F", gikal, 3))
	endif
	arm1(4, $mf)

	gkroy_top3 = 0
endif

if gkroy_top4 == 1 then
	$when(eujo(3, 8, 16))
		eva("orphans3",
		gkbeats*$once(6, 1),
		accent(5, $f),
		$once(gilikearev$atk(5), giclassicr),
		step("2F", gikal, 4))
	endif
	arm1(4, $mf)


	gkroy_top4 = 0
endif


if gkroy_top5 == 1 then
	$when(eujo(3, 8, 16))
		eva("orphans3",
		gkbeats*$once(6, 1),
		accent(5, $f),
		$once(gilikearev$atk(5), giclassicr),
		step("2F", gikal, 5))
	endif
	arm1(4, $mf)


	gkroy_top5 = 0
endif

if gkroy_top6 == 1 then
	$when(eujo(3, 8, 16))
		eva("orphans3",
		gkbeats*$once(6, 1),
		accent(5, $f),
		$once(gilikearev$atk(5), giclassicr),
		step("2F", gikal, 6))
	endif
	arm1(4, $mf)


	gkroy_top6 = 0
endif

if gkroy_top7 == 1 then
	$when(eujo(3, 8, 16))
		eva("orphans3",
		gkbeats*$once(6, 1),
		accent(5, $f),
		$once(gilikearev$atk(5), giclassicr),
		step("2F", gikal, 7))
	endif
	arm1(4, $mf)


	gkroy_top7 = 0
endif

if gkroy_top8 == 1 then
	$when(eujo(3, 8, 16))
		eva("orphans3",
		gkbeats*$once(6, 1),
		accent(5, $f),
		$once(gilikearev$atk(5), giclassicr),
		step("2F", gikal, 8))
	endif
	arm1(4, $mf)


	gkroy_top8 = 0
endif

	endin
	start("score")

	
	instr route

flingj3("burd", lfh(9), .5)
convj("arm1", "orphans3")
getmeout("qb")
getmeout("between")
getmeout("orphans3")

	endin
	start("route")

