	instr score

kstep	pump 2, fillarray(0, 0, -2, -1)

$if	eu(11, 16, 16, "heart") $then
	e("haisentitoditom",
	gkbeats,
	$ff,
	step("3C", gimajor, pump(64, fillarray(1, 0, 2, 0, 8, 4, 2, 0, 3)), kstep))
endif

$if	eu(11, 16, 16, "heart", 3) $then
	e("haisentitoditom",
	gkbeats,
	$ff,
	step("3D", gimajor, pump(64, fillarray(1, 0, 2, 0, 8, 4, 2, 0, 3)), kstep))
endif

	endin
	start("score")
	instr route
getmeout("haisentitoditom")
	endin
	start("route")
