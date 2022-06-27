;---ANAL
;opcode  ---NAME---, 0, SJJjjPo
;Sinstr, kpitch, kfb, iwin, ift, kgain, ich

kdel		= gkbeatms/12

aout		vdelay3 ain + (a(kdel)*kfb), a(kdel)/1000, 5000

fs1, fsi2	pvsifd		aout, iwin, iwin/8, 1			; ifd analysis
fst			partials	fs1, fsi2, 0.035, 1, 3, 512		; partial tracking
aout		resyn		fst, 1, kpitch, 512, ift		; resynthesis (up a 5th)
