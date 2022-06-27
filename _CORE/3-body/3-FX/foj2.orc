;---FREQ
;opcode  ---NAME---, 0, SJJPo
;Sinstr, kfreq, kq, kgain, ich xin

;xris -- impulse response attack time (secs).
;xdec -- impulse response decay time (secs).

ifreq_var	init 5

kris	= kq
kdec	= 1-kq

kdec	limit kdec, 0, kris*2

aout	fofilter ain, kfreq+randomi:k(-ifreq_var, ifreq_var, .05), kris/1000, kdec/1000
aout	fofilter aout, kfreq+randomi:k(-ifreq_var, ifreq_var, .05)*2, kris/500, kdec/500
