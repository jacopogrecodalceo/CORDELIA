	instr score

gkpulse = 120

if gkroy_top1 == 1 then
	eva("distmar",
	gkbeats*$once(4, 1),
	accent(5, $f),
	giclassic$atk(5),
	step("4F", giminor, $once(1, 3, 5, 7)))

	gkdistmar_sonvs += 1
	gkdistmar_sonvs = gkdistmar_sonvs%gidistmar_len

	gkroy_top1 = 0

endif

if gkroy_top5 == 1 then
	eva("dismatter",
	gkbeats*$once(4, 1),
	accent(5, $f),
	giclassic$atk(5),
	step("4F", giminor, $once(1, 3, 5, 7)))

	gkdismatter_sonvs += 1
	gkdismatter_sonvs = gkdismatter_sonvs%gidismatter_len

	gkroy_top5 = 0

endif

	endin
	start("score")

	
	instr route

getmeout("distmar", follow2(limit(a(gkmo_top5), 0, 1), .025, .025))


getmeout("dismatter", follow2(limit(a(gkmo_top5), 0, 1), .025, .025))


	endin
	start("route")

