;---TIME_FT
;opcode  ---NAME---, 0, SJJjPo
;Sinstr, ktime, kfb, ift, kgain, ich xin

kfreq		= ktime
kms			= (1/ktime)*(gkbeats/12)

kndx	= ((chnget:k("heart")*gkdiv/ginchnls))%1
kndx	= (int(kndx*ginchnls)+ich)%ginchnls

;	INSTRUMENT
ar_out	= ain * oscili:a(1, kfreq*giringj7_arr[kndx], ift)

;	DELAY
af_out	flanger ar_out, a(kms), kfb

aout	= ar_out + af_out
