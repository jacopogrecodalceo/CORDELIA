	instr score

gkpulse = 120

if eujo(4, 8, 8) == 1 then
	eva("noinput",
	gkbeats*$once(4, 1),
	accent(5, $ff),
	giclassic$atk(5),
	step("4F", giminor, $once(1, 3, 5, 7)))

	gknoinput_sonvs += 1
	gknoinput_sonvs = gknoinput_sonvs%ginoinput_len

endif

	endin
	start("score")

	
	instr route

getmeout("noinput")

	endin
	start("route")

