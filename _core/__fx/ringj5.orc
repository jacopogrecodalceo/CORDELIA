;---TIME_FT
;opcode  ---NAME---, 0, SJJjPo
;Sinstr, ktime, kfb, ift, kgain, ich xin

kfreq		= ktime
kms			= (1/ktime)*(gkbeats/12)

ar_out	= ain * oscili:a(1, kfreq, ift)

if gkringj5_port==0 then
	adel	a kms
else
	adel	a portk(kms, gkringj5_port)
endif

;	DELAY
af_out	flanger ar_out, adel, kfb

aout	= af_out * oscili:a(1, kfreq, ift)
