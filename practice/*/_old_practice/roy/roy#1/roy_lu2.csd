	instr score

gkpulse = 50

gkmo_topsum = gkmo_top1 + gkmo_top2 + gkmo_top3 + gkmo_top4 + gkmo_top5 + gkmo_top6 + gkmo_top7 + gkmo_top8

gkorphans3_vib = portk((gkmo_topsum*35), 50$ms)

if gkroy_top1 == 1 then
	$when(eujo(3, 8, 16))
		eva("orphans3",
		gkbeats*6,
		accent(5, $fff),
		$once(gilikearev$atk(5), giclassic),
		step("3Eb", gimixolydian, 1))
	endif

	gkroy_top1 = 0
endif

if gkroy_top2 == 1 then
	$when(eujo(3, 8, 16))
		eva("orphans3",
		gkbeats*6,
		accent(5, $fff),
		$once(gilikearev$atk(5), giclassic),
		step("3Eb", gimixolydian, 2))
	endif

	gkroy_top2 = 0
endif

if gkroy_top3 == 1 then
	$when(eujo(3, 8, 16))
		eva("orphans3",
		gkbeats*6,
		accent(5, $fff),
		$once(gilikearev$atk(5), giclassic),
		step("3Eb", gimixolydian, 3))
	endif

	gkroy_top3 = 0
endif

if gkroy_top4 == 1 then
	$when(eujo(3, 8, 16))
		eva("orphans3",
		gkbeats*6,
		accent(5, $fff),
		$once(gilikearev$atk(5), giclassic),
		step("3Eb", gimixolydian, 4))
	endif


	gkroy_top4 = 0
endif


if gkroy_top5 == 1 then
	$when(eujo(3, 8, 16))
		eva("orphans3",
		gkbeats*6,
		accent(5, $fff),
		$once(gilikearev$atk(5), giclassic),
		step("3Eb", gimixolydian, 5))
	endif


	gkroy_top5 = 0
endif

if gkroy_top6 == 1 then
	$when(eujo(3, 8, 16))
		eva("orphans3",
		gkbeats*6,
		accent(5, $fff),
		$once(gilikearev$atk(5), giclassic),
		step("3Eb", gimixolydian, 6))
	endif


	gkroy_top6 = 0
endif

if gkroy_top7 == 1 then
	$when(eujo(3, 8, 16))
		eva("orphans3",
		gkbeats*6,
		accent(5, $fff),
		$once(gilikearev$atk(5), giclassic),
		step("3Eb", gimixolydian, 7))
	endif


	gkroy_top7 = 0
endif

if gkroy_top8 == 1 then
	$when(eujo(3, 8, 16))
		eva("orphans3",
		gkbeats*6,
		accent(5, $fff),
		$once(gilikearev$atk(5), giclassic),
		step("3Eb", gimixolydian, 8))
	endif


	gkroy_top8 = 0
endif


	endin
	start("score")

	
	instr route

flingj3("burd", lfh(9), .5)
convj("gesto2", "orphans3")
getmeout("qb")
getmeout("between")
getmeout("orphans3")

	endin
	start("route")

