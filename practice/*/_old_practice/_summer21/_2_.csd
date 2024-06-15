	instr score

gkpulse	= 90

gkgrind_p1 go 1, 5, 5.5

if (hex("89a", 8) == 1) then
	eva("grind",
	gkbeats*4,
	$fff,
	gibite,
	step("3D", gimjnor, pump(8, fillarray(1, 1, 2, 7))))
endif

	endin
	start("score")

	
	instr route

getmeout("grind")
getmeout("puck")

	endin
	start("route")

