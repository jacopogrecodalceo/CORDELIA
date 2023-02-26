	instr score

gkpulse	= 115

hmelody("puck",
	1,
	3,
	$f,
	"3A",
	gklostwoods)

	endin
	start("score")

	instr route
getmeout("puck")
	endin
	start("route")
