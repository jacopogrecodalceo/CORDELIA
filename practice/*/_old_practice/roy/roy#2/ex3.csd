	instr score

gkpulse = 90

$when(eujo(3, 8, 8))
	eva("maij",
	gkbeats*8,
	accent(3, $f)*(1-limit(gkmo_top1, 0, 1)),
	$once(giatri, gidiocle),
	step("1Eb", gimixolydian, random:k(1, 12)))
endif


$when(eujo(3, 8, 8))
	eva("ocean",
	gkbeats*8,
	accent(3, $p),
	$once(giatri, gidiocle),
	step("3Eb", gimixolydian, random:k(1, 12)))
endif

	endin
	start("score")

	
	instr route

getmeout("ocean", (1-k(follow2(limit(a(gkmo_top1), 0, 1), .125, .325)))*comeforme(45))

	endin
	start("route")

