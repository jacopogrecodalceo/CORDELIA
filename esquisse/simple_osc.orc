
nchnls  = 2
ksmps   = 2
0dbfs   = 1
sr		= 48000

	instr 1

idur		init p3
idyn		init p4
icps		init p5

aout		oscili portk(1/(active:k(1)+1)*idyn, .005), icps
aout		*= linseg:a(0, .005, 1, idur-.005, 0)

    outall aout
	endin
