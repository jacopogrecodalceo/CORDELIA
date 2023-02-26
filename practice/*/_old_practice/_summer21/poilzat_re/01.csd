	instr score

gkpulse	= 90

gketag_dur = .5
gketag_time randomh .25, 2, gkbeatf*2

etag(8, $f)
etag(16, $f)

	endin
	start("score")

	
	instr route

moogj("etag", pump(16, fillarray(.05, 3, .05, 1)*1000))
moogj("etag", pump(24, fillarray(.5, 3, .5, 1)*100))


	endin
	start("route")

