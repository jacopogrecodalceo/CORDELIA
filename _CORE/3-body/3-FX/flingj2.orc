;---TIME
;opcode  ---NAME---, 0, SJJPo
;Sinstr, ktime, kfb, kgain, ich xin

imaxfb		init .995
kdel        = ktime

a1		flanger ain, a(kdel)/1000, kfb%imaxfb

kdel	*= 2
kfb		*= 2
a2		flanger a1, a(kdel)/1000, kfb%imaxfb

kdel	*= 3
kfb		*= 3
a3		flanger a2, a(kdel)/1000, kfb%imaxfb

aout		= a3
