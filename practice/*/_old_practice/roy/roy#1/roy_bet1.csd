	instr 964

gkpulse = 120

; TOP1
if gkroy1 == 1 then

	gkalone_cps = 20+limit(gkmo_top1, 0, 1)*20

endif


if gkroy_top1 == 1 then

	eva("alone",
	gkbeats*$once(1, 1, 1, 1, 3),
	accent(3, $p),
	giclassic,
	step("5F", giquarter, 12+$once(1, 3, 5, 7, 3, 1, 3, 9, 10)))

	gkroy_top1 = 0

endif


; TOP2
if gkroy_top2 == 1 then

	gkventre_lad portk 1500+limit(gkmo_top1, 0, 1)*15000, 20

	eva("ventre",
	gkbeats,
	accent(3, $p),
	giclassic,
	step("0F", giquarter, 12+$once(1, 3, 5, 7, 3, 1, 3, 9, 10)))


	eva("valle",
	gkbeats,
	accent(3, $p),
	giclassic,
	step("2F", giquarter, 12+$once(1, 3, 5, 7, 3, 1, 3, 9, 10)))
	gkroy_top2 = 0

endif



	endin
	start(964)



	
	instr ruote

getmeout("alone")
getmeout("wutang")
getmeout("ventre", 32)
getmeout("valle")
pitchj("inmic1", 1-(lfh(2)*.5), 0, 10, gisine, 9)
pitchj("inmic1", 1+(lfh(1)*5), 0, 10, gisine, 9)
shjnot("inmic1", .85, 3)
	endin
	start("ruote")



