;---TIME
;opcode  ---NAME---, 0, SJJPo
;Sinstr, ktime, kfb, kgain, ich xin

aout    init 0
kdel	= ktime

aout		vdelay3	ain + (aout*a(kfb)), a(kdel*ich), 5$k
