;---TIME_FT
;opcode  ---NAME---, 0, SJJjPo
;Sinstr, ktime, kfb, ift, kgain, ich xin

kdiv		= ktime
kphase		= kdiv%1

korgan		chnget "heart"
kndx		= ((korgan*kdiv*gkdiv)+kphase)%1

kring		table3 kndx, ift, 1
kring		portk kring, 5$ms
aring		a kring

;	INSTRUMENT
ar_out	= ain * aring

;	DELAY
if gkringhj5_port == 0 then
	adel	a gkbeats/kdiv
else
	adel	a portk(gkbeats/kdiv, gkringhj5_port)
endif

af_out	flanger ar_out, adel, kfb

aout	= af_out * aring
