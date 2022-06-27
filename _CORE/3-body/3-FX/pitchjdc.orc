;---ANAL
;opcode  ---NAME---, 0, SJJjjPo
;Sinstr, kpitch, kfb, iwin, ift, kgain, ich

kdel        = gkbeats/12

if	kfb!=0 then
	aout	flanger ain, a(kdel)/1000, kfb
else
	aout = ain
endif

fs1, fsi2	pvsifd		aout, iwin, iwin/8, 1			;ifd analysis
fst		partials	fs1, fsi2, 0.035, 1, 3, 256		;partial tracking
aout		resyn		fst, 1, kpitch, 256, ift		;resynthesis (up a 5th)

aout		dcblock2 aout
