;---OP1
;opcode  ---NAME---, 0, SJJPo
;Sinstr, kp1, kgain, ich xin

ift     init gisigm1
kdist	= kp1

aout    distort ain, kdist, ift;[, ihp, istor]
aout	balance2 aout, ain
