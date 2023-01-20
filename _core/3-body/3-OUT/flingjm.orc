;---TIME
;opcode  ---NAME---, 0, SJJPo
;Sinstr, ktime, kfb, kgain, ich xin

kdel    = ktime

aoutf	flanger ain, a(kdel)/1000, kfb

kfreq	= 1/(ktime/1000)
kfreq	limit kfreq, gizero, gkbeatf*4

aoutm	moogladder2 aoutf, 25+oscili:a(7.5$k*kfb, kfreq, giflingjm_ft), limit(.995-kfb, 0, .995)
aoutm	flanger aoutm, a(kdel)/500, kfb

aout	= aoutf + balance2(aoutm, aoutf)
aout	/= 2


