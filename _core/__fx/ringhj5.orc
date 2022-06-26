;---TIME_FT
;opcode  ---NAME---, 0, SJJjPo
;Sinstr, ktime, kfb, ift, kgain, ich xin

kdiv		= ktime
kphase		abs floor(kdiv)-kdiv

andx		a chnget:k("heart")
andx		= ((andx*kdiv*gkdiv)+kphase)%1

;	INSTRUMENT
ar_out	= ain * tablei:a(andx, ift, 1)

;	DELAY
if gkringhj5_port==0 then
	adel	a gkbeats/kdiv
else
	adel	a portk(gkbeats/kdiv, gkringhj5_port)
endif

af_out	flanger ar_out, adel, kfb

aout	= af_out * tablei:a(andx, ift, 1)
