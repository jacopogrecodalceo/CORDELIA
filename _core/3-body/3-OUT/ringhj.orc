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

;		OUT
aout	= ain * aring
