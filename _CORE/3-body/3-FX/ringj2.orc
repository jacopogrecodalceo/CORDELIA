;---TIME_FT
;opcode  ---NAME---, 0, SJJjPo
;Sinstr, ktime, kfb, ift, kgain, ich xin

kfreq		= ktime
kms			= (1/ktime)*(gkbeats/12)

aout	= ain * oscili:a(1, kfreq, ift)

;	DELAY
aout	flanger aout, a(kms), kfb
