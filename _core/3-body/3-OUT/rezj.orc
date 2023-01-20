;---FREQ
;opcode  ---NAME---, 0, SJJPo
;Sinstr, kfreq, kq, kgain, ich xin

ifreq_var	init 5

aout	rezzy ain, kfreq+randomi:k(-ifreq_var, ifreq_var, .05), kq*100
aout	balance2 aout, ain
