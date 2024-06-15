	instr score

gkpulse	= 90

kvar	pump 8, fillarray(1, 2, 4, .5)

$if eu(5, 16, 2*kvar, "heart") $then
	eva("wutang",
	gkbeats*once(fillarray(1, .5, .5, random:k(.5, 2)))*12,
	accent(3, $fff),
	giclassic$atk(5),
	step("4D", gimjnor, random:k(1, 15)),
	step("2D", gimjnor, random:k(1, 15)),
	step("3D", gimjnor, random:k(1, 15)))
endif

$if eu(2, 16, 2*kvar, "heart") $then
	eva("witches",
	gkbeats*once(fillarray(1, .5, .5, random:k(.5, 2)))*12,
	accent(3, $p),
	giclassic$atk(5),
	step("4D", gimjnor, random:k(1, 15)),
	step("2D", gimjnor, random:k(1, 15)),
	step("3D", gimjnor, random:k(1, 15)))
endif
	endin
	start("score")

	instr route

;ringj3("wutang", gkbeatf/4, oscil3:k(.95, gkbeatf*4, gilowatri), gisine, oscil3:k(1, gkbeatf, gilowatri))
;ringhj3("wutang", 2, lfh:k(gkdiv*(2+int(randomi:k(2, 9, gkbeatf/4))), gilowatri), gisine, lfh:k(gkdiv, gilowatri))
;ringhj3("wutang", 3, lfh:k(gkdiv*(2+int(randomi:k(2, 9, gkbeatf/3))), gilowatri), gisine, lfh:k(gkdiv, gilowatri))
moogj("wutang", ntof("1D")+ntof("6D")*lfh:k(gkdiv/4), lfh:k(gkdiv)/2)
moogj("wutang", ntof("2D")+ntof("5D")*lfh:k(gkdiv), lfh:k(gkdiv)/4)
pitchj("wutang", pump(8, fillarray(.5, 1, 1, 3/2))+lfh(3, gilikearevr), gkbeatms*pump(8, fillarray(.25, 1, .5, .125)), .35)

moogj("witches", ntof("3D")+ntof("7D")*lfh:k(gkdiv*1.5), lfh:k(gkdiv)/4)
pitchj("witches", pump(16, fillarray(.25, 2, 1, 3/2)), gkbeatms*pump(24, fillarray(.25, 1, .5, .125)), .75)
ringhj3("witches", 3, lfh:k(gkdiv*(2+int(randomi:k(2, 9, gkbeatf/3))), gilowatri), gisine, lfh:k(gkdiv, gilowatri))

	endin
	start("route")
