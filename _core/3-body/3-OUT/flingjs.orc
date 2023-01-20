;---TIME
;opcode  ---NAME---, 0, SJJPo
;Sinstr, ktime, kfb, kgain, ich xin

kdel    	= ktime
kdel		+= randomi:k(0, kdel/4, .25/kdel)

aout		flanger ain, a(kdel)/1000, kfb
