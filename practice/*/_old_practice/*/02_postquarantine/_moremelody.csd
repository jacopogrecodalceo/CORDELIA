	instr Score

hmelody("puck",
	2,
	$mf,
	"3Ab",
	#bach)

hmelody("repuck",
	4,
	$mf,
	"3Ab",
	#bach)

	endin
	start("Score")

	instr Route

getmeout("puck")
getmeout("repuck")

	endin
	start("Route")

