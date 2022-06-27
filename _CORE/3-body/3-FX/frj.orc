;---ANAL
;opcode  ---NAME---, 0, SJJjjPo
;Sinstr, kpitch, kfb, iwin, ift, kgain, ich

kdel        = gkbeats/12

if	kfb!=0 then
	aout	flanger ain, a(kdel)/1000, kfb
else
	aout = ain
endif

ifftsize       	init iwin
ioverlap	init ifftsize / 4
iwinsize	init ifftsize

kamp		= kpitch
kamp		limit kamp, 0, 1
kfreq		= kpitch

fftin		pvsanal	ain, ifftsize, ioverlap, iwinsize, 0
freeze		pvsfreeze fftin, kamp, .5+kfreq ;freeze amps or freqs independently
aout		pvsynth	freeze ;resynthesize

aout 		*= kamp	
