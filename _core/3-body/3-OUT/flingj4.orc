;---TIME
;opcode  ---NAME---, 0, SJJPo
;Sinstr, ktime, kfb, kgain, ich xin

imaxfb		init .995
kdel        = ktime

a1		flanger ain, a(kdel)/1000, portk(kfb%imaxfb, 15$ms)
kdel		*= 2
a2		flanger ain, a(kdel)/1000, portk(kfb%imaxfb, 15$ms)
kdel		*= 3
a3		flanger ain, a(kdel)/1000, portk(kfb%imaxfb, 15$ms)
aout	= a1 + a2 + a3
