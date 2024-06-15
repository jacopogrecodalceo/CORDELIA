	instr score

gkpulse	= 120

k1	= 1+(4*lfh(2))

$if hex("824a", 48) $then
	gksinimp_sonvs once fillarray(1, random:k(1, gisinimp_len), random:k(1, gisinimp_len), gisinimp_len/2, gisinimp_len-15)
endif

sinimp(32*3, $f)
sinimp(32*2, $mf)

kch	int go(1, 25, 16)
gksinimp_dur = .5 + (lfh(kch, gisine)*.45)
gksinimp_off lfh 2

	endin
	start("score")

	instr route

flingj("sinimp", gkbeatms/2, lfh(8)*.5)
pitchj("sinimp", pump(32, fillarray(2, 3/2, 4, 3)), .65, 9, gisquare, lfh(12))
;pitchj("sinimp", 4, .65, 9, gisaw, lfh(12))

	endin
	start("route")

