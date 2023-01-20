;---TIME_FT
;opcode  ---NAME---, 0, SJJjPo
;Sinstr, ktime, kfb, ift, kgain, ich xin

kfreq		= ktime

kspeedmod	oscil3 1, kfreq, ift
kspeedmodp	portk kspeedmod, .05	;smooth
aspeedmod	interp kspeedmodp	;convert lfos to a-rate

adelspeed 	= 5*abs(aspeedmod)			;speed is modulated by LFO
adel		vdelay ain, adelspeed, gibeatms*8
 
aout		= (ain*kfb)+adel
aout		balance2 aout, ain
