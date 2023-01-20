;---TIME_FT
;opcode  ---NAME---, 0, SJJjPo
;Sinstr, ktime, kfb, ift, kgain, ich xin

kfreq		= ktime
kms		= (1/ktime)*(gkbeats/12)

ar_out	= ain * oscili:a(1, kfreq, ift)

;	DELAY
af_out	flanger ar_out, a(kms), kfb

igain	init 2

aout	= ar_out/igain + af_out/igain
