instr SCORE

	knum	init 1

	ipulses	= 11
	ionset	= 9

	ktrig	= euph(ionset, ipulses)
	
	printf("•", (ktrig == 0 ? 1 : 0))
	printf("%d", ktrig, knum)
	printf("\n\n---\n", (knum == (ionset-1) ? 1 : 0))
	
	if	(ktrig == 1) then
		schedulek("Puck", 0, 1, in_scale(0, 3), .25, .5)
		knum	= (knum % ionset) + 1
	endif

endin

instr Cycle
	aph	chnget "master"

	klast init -1
	ktrig	= (k(aph) < klast ? 1 : 0)
	klast	= k(aph)

	printf("\n---Im sending a bang\n", ktrig)
	schedkwhen(ktrig, 0, 12, "SCORE", 0, beats(1))
endin

schedule("Cycle", 0, measures(1))
