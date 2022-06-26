;---ANAL
;opcode  ---NAME---, 0, SJJjjPo
;Sinstr, kpitch, kfb, iwin, ift, kgain, ich

fs1, fsi2	pvsifd		ain, iwin, iwin/4, 1			;ifd analysis
fst		partials	fs1, fsi2, 0.035, 1, 3, 500		;partial tracking
fscl		trshift		fst, kpitch						;frequency shift
aout		tradsyn		fscl, 1, 1, 500, ift			;resynthesis

if kfb > 0 then
	aout	flanger aout, a(gkbeats/12), kfb
endif
