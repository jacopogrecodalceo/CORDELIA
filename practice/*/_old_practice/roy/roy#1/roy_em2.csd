	instr score

gkpulse = 30-(pump(12, fillarray(0, 25, 0, 0))*cosseg(1, 75, 0))

$when(gkroy_top1)
	eva("grind",
	gkbeats*12,
	accent(3, $ppp),
	giclassic,
	step("5F", giquarter, 12+$once(1, 3, 5, 7, 3, 1, 3, 9, 10)))

	gkroy_top1 = 0

endif

gkgrind_p2 limit gkmo_top5, 0, 1
printk2 gkgrind_p2

	endin
	start("score")


	
	instr ruote

getmeout("grind")

	endin
	start("ruote")



