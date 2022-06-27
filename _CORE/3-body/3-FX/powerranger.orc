;---OP1
;opcode  ---NAME---, 0, SJJPo
;Sinstr, kp1, kgain, ich xin

kshape	= kp1

aout	powershape ain, kshape
aout	balance2 aout, ain
