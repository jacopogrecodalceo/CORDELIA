	instr score

gkpulse = 50-k(follow2(limit(a(gkmo_top5), 0, 1), .025, 3))*35

ift init gipentamin
kch pump 8, fillarray(0, -1, 0, 5, 1, 3)

kdyn = 16+lfh(2)*32

$if hex("8", 3) $then
	eva("noij",
	gkbeats*random(6, 12),
	pump(12, fillarray($ff, $mf, $mf, $mf))/kdyn,
	giatri,
	step("4Eb", ift, 5+$once(1, 3)),
	step("2C", ift, kch+2+$once(1, 3, 1, 6)),
	step("1G", ift, kch+$once(1, 3, 1, 6)))
endif

$if hex("8", 3) $then
	eva("fairest3",
	gkbeats*random(6, 12)*2,
	pump(12, fillarray($ff, $mf, $mf, $mf))/2,
	giatri,
	step("4G", ift, kch+$once(1, 3, 1, 6)))
endif
	endin
	start("score")

	
	instr route

getmeout("noij", (1-follow2(limit(a(gkmo_topsum), 0, 1), .025, 5)))
pitchj2("fairest3", int(1+lfh(48*2, gidiocle)*3)+lfo(.05, gkbeatf*portk(int(4+lfh(6)*6), gkbeats/12)), .15, 13, gitri)

	endin
	start("route")

