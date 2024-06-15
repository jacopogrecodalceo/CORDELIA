	instr score

gkpulse	= 120-(((chnget:k("heart")*8)%1)>.75 ? 95 : 0)

gketag_dur = .5
gketag_time randomh .25, 2, gkbeatf*2

etag(8, $pp)
etag(16, $pp)
ninfa(8, $p)

if (eu(2, 8, 16, "heart") == 1) then
	e("fim",
	gkbeats*16,
	accent(9, $ppp),
	once(fillarray(gieclassic, giclassic)),
	step("4G", gimjnor, once(fillarray(2, 7, 3, 2, 7))),
	step("4G", gimjnor, once(fillarray(1, 2, 7, 3, 2, 7))))
endif

	endin
	start("score")

	
	instr route
moogj("fim", pump(24, fillarray(.05, 3, .05, 1)*1000))


moogj("etag", pump(16, fillarray(.05, 3, .05, 1)*1000))
flingj("etag", pump(24, fillarray(.5, .25, .5, 1)*gkbeats), .995)
flingj("ninfa", pump(24, fillarray(.5, .25, .5, 1)*gkbeats), .995)

	endin
	start("route")

