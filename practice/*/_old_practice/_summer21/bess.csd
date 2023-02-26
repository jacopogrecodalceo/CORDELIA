	instr score

gkpulse	= 73.5

gkarm1_dur = .5

arm1(pump(4, fillarray(2, 0, 0, 0)), $mf)
;arm2(pump(2, fillarray(1, 1, 0)), $mf)

if (hex("8000", 8) == 1) then
	eva(oncegen(girot), "fim",
	gkbeats*4,
	$mf,
	once(fillarray(gieclassic, giclassic)),
	step("2B", gikumoi, 1+pump(4, fillarray(3, 2, 2, 5))),
	step("2B", gikumoi, pump(4, fillarray(1, 1, 2, 5))))
endif

	endin
	start("score")

	instr route
flingj("arm1", pump(6, gkbeatms-fillarray(5, 25, 5, 125)), .95)
;flingj4("arm2", pump(12, fillarray(5, 25, 5, 125))*.85, .95)

;flingj3("fim", oscil:k(gkbeatms, gkbeatf/lfse(2, 12, gkbeatf/32), gispina), .05)

	endin
	start("route")
