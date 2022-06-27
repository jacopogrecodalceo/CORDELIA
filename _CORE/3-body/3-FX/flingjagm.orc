;---TIME
;opcode  ---NAME---, 0, SJJPo
;Sinstr, ktime, kfb, kgain, ich xin

kdel    = ktime
adel	= a(kdel)/1000

aout	flanger ain, adel, kfb, 15

aout	*= kgain
