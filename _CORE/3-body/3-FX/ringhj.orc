;---TIME_FT
;opcode  ---NAME---, 0, SJJjPo
;Sinstr, ktime, kfb, ift, kgain, ich xin

kdiv		= ktime
kphase		abs floor(kdiv)-kdiv

andx		a chnget:k("heart")
andx		= ((andx*kdiv*gkdiv)+kphase)%1

;		OUT
aout	= ain * tablei:a(andx, ift, 1)
