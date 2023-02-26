instr Chit1

	root("3G")

	if	(euph(2, 7) == 1) then
		event("i", "Puck", 0, 1, in_scale(0, 1), .25, .5)
	elseif	(euph(2, 15) == 1) then
		event("i", "Puck", 0, 1, in_scale(0, 2), .25, .5)
	elseif	(euph(2, 25) == 1) then
		event("i", "Puck", 0, 1, in_scale(0, 6), .25, .5)
	endif

endin

instr Chit2

	root("3E")	

	if	(euph(2, 7) == 1) then
		event("i", "Puck", 0, 1, in_scale(-1, 6), .25, .5)
	elseif	(euph(2, 15) == 1) then
		event("i", "Puck", 0, 1, in_scale(0, 2), .25, .5)
	elseif	(euph(2, 25) == 1) then
		event("i", "Puck", 0, 1, in_scale(0, 1), .25, .5)
	endif

endin

schedule("Chit1", 0, measures(4))
schedule("Chit2", measures(4), measures(4))

