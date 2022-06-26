;---ANAL
;opcode  ---NAME---, 0, SJJjjPo
;Sinstr, kpitch, kfb, iwin, ift, kgain, ich

fs1, fsi2	pvsifd		ain, iwin, iwin/4, 1			;ifd analysis
fst			partials	fs1, fsi2, 0.035, 1, 3, 500		;partial tracking
aout		resyn		fst, 1, kpitch, 500, ift		;resynthesis (up a 5th)
