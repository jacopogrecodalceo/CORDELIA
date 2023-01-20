;---OP1
;opcode  ---NAME---, 0, SJJPo
;Sinstr, kp1, kgain, ich xin

kfreq	= kp1

afx	abs ain
afx	balance2 afx, ain

amod	abs lfo:a(1, kfreq/2)

afx	*= (1-amod)
ain	*= amod

aout	= afx + ain
