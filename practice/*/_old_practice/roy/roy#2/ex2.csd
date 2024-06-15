	instr score

gkpulse = 70

kvib = 5+lfa(35, 1/8)

;NATURE
gkorphans3_vib = k(follow2(limit(a(gkmo_topsum), 0, 1), .035, 2))*kvib

;CONTRENATURE
;gkorphans3_vib = kvib-(k(follow2(limit(a(gkmo_topsum), 0, 1), .035, 2))*kvib)

kdyn = $mf
ift = giclassic$atk(5)
Sroot = "3D"
ko = 1
kdur1 = 6

if gkroy_top1 == 1 then
	$when(eujo(3, 8, 16))
		eva("orphans3",
		gkbeats*$once(kdur1, 1),
		accent(5, kdyn),
		ift,
		step(Sroot, gikal, 1)*ko)
	endif
	arm1(4, $mf)

	gkroy_top1 = 0
endif

if gkroy_top2 == 1 then
	$when(eujo(3, 8, 16))
		eva("orphans3",
		gkbeats*$once(kdur1, 1),
		accent(5, kdyn),
		ift,
		step(Sroot, gikal, 2)*ko)
	endif
	arm1(4, $mf)

	gkroy_top2 = 0
endif

if gkroy_top3 == 1 then
	$when(eujo(3, 8, 16))
		eva("orphans3",
		gkbeats*$once(kdur1, 1),
		accent(5, kdyn),
		ift,
		step(Sroot, gikal, 3)*ko)
	endif
	arm1(4, $mf)

	gkroy_top3 = 0
endif

if gkroy_top4 == 1 then
	$when(eujo(3, 8, 16))
		eva("orphans3",
		gkbeats*$once(kdur1, 1),
		accent(5, kdyn),
		ift,
		step(Sroot, gikal, 4)*ko)
	endif
	arm1(4, $mf)


	gkroy_top4 = 0
endif


if gkroy_top5 == 1 then
	$when(eujo(3, 8, 16))
		eva("orphans3",
		gkbeats*$once(kdur1, 1),
		accent(5, kdyn),
		ift,
		step(Sroot, gikal, $once(5, 9, 5, 8))*ko)
	endif
	arm1(4, $mf)


	gkroy_top5 = 0
endif


	endin
	start("score")

	
	instr route

convj("arm1", "orphans3", 4)
getmeout("orphans3", 4)

	endin
	start("route")

