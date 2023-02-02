	instr 400
gkrhy_i410 eujo 3, 8, 8
	endin
	turnoff2_i 400, 0, 0
	schedule 400, 0, -1

	instr 401
gkspace_i410 = 0
	endin
	turnoff2_i 401, 0, 0
	schedule 401, 0, -1

	instr 402
gkdur_i410 = gkbeats
	endin
	turnoff2_i 402, 0, 0
	schedule 402, 0, -1

	instr 403
gkdyn_i410 = $f
	endin
	turnoff2_i 403, 0, 0
	schedule 403, 0, -1

	instr 404
 gkenv_i410 = giasquare
	endin
	turnoff2_i 404, 0, 0
	schedule 404, 0, -1

	instr 405
 gkfreq_i410 pump 4, fillarray(1, 2, 3)*400
	endin
	turnoff2_i 405, 0, 0
	schedule 405, 0, -1

	instr 410
if gkrhy_i410 == 1 then
	eva(gkspace_i410, "puck", 
	gkdur_i410,
	gkdyn_i410,
	gkenv_i410, 
	gkfreq_i410)
endif
getmeout("puck")
	endin
	turnoff2_i 410, 0, 0
	schedule 410, 0, -1


	schedule 950.1, 0, -1, "puck_1"
	schedule 950.2, 0, -1, "puck_2"
