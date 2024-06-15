	start("Score")

	instr Score

Lau("/Users/j/Documents/my_csound/_my_livecode/loop_copiedisk/aïgu_2.wav", 6, $ff)

if (eu(2, 9, 2) == 1) then
	Lau("/Users/j/Documents/my_csound/_my_livecode/loop_copiedisk/impact_1.wav", 12, $fff)
elseif (eu(2, 32, 6) == 1) then
	Lau("/Users/j/Documents/my_csound/_my_livecode/loop_copiedisk/aïgu_4.wav", 8, $ff)
endif	

;chnset(golin(500, 25, 3500), "Moog.freq")
;routemeout("Lawrence", "Moog")
getmeout("Laurence")

	endin
