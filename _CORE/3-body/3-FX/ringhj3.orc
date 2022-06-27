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
adel    a gkbeats/12 ; it must be in second
af_out	flanger ar_out, adel, kfb

aout	sum ar_out, af_out
