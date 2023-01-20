;---TIME
;opcode  ---NAME---, 0, SJJPo
;Sinstr, ktime, kfb, kgain, ich xin

kdel    = ktime

arev	nreverb ain, ktime, 1-kfb

aout	= (ain + arev)/2
