;---FREQ
;opcode  ---NAME---, 0, SJJPo
;Sinstr, kfreq, kq, kgain, ich xin

aguid	wguide1 ain, 1/kfreq, kfreq/2, kq

astr1	streson ain, kfreq, kq
astr2	streson ain, kfreq*1.25, kq

aout	= aguid + astr1 + astr2
aout	/= 3

aout	phaser1 aout, kfreq, 12, kq
