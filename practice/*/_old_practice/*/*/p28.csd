instr euSCORE


	if	(euph(2, 3) == 1) then
		event("i", "Puck", 0, 1, in_scale(0, 1), .25, .5)
	elseif	(euph(1, 9) == 1) then
		event("i", "Puck", 0, 1, in_scale(0, 2), .25, .05)
	elseif	(euph(5, 30) == 1) then
		event("i", "Puck", 0, 1, in_scale(0, 6), .25, .5)
	endif

endin

instr Cycle
	aph	chnget "master"

	klast init -1
	ktrig	= (k(aph) < klast ? 1 : 0)
	klast	= k(aph)

	printf("\n---Im sending a bang\n", ktrig)
	schedkwhen(ktrig, 0, 32, "euSCORE", 0, beats(1))
endin

schedule("Cycle", 0, -1)

stop("Cycle")
