	instr score

gkpulse	= 120

k1	= 1+(4*lfh(2))

ilen	init gichime_len

$if hex("f18", 16) $then
	gkchime_sonvs once fillarray(0, random:k(0, ilen), 2)
endif

chime(4, $mp)

	endin
	start("score")

	instr route

getmeout("chime")

	endin
	start("route")

