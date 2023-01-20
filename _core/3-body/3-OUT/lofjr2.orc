;---TIME
;opcode  ---NAME---, 0, SJJPo
;Sinstr, ktime, kfb, kgain, ich xin

kbits    = ktime

kvalues		pow		2, kbits					    ;RAISES 2 TO THE POWER OF kbitdepth. THE OUTPUT VALUE REPRESENTS THE NUMBER OF POSSIBLE VALUES AT THAT PARTICULAR BIT DEPTH
aout		=	(int((ain/0dbfs)*kvalues))/kvalues	;BIT DEPTH REDUCE AUDIO SIGNAL
aout		fold 	aout, 64*kfb

arev		nreverb aout, gkbeats*8, 1-kfb

aout	= (aout + arev/4)/2
