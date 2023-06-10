gkgrind2_p1	init 1

	$START_INSTR(grind2)
	$dur_var(10)

igrind		i gkgrind2_p1

aex		fractalnoise $dyn_var, cosseg(1, idur, 0)
;aex		*= cosseg(0, 5$ms, $dyn_var, 5$ms, 0)
aex		*= cosseg(0, idur/128, $dyn_var, idur/256, 0)

af		flanger aex/3, idur/cosseg:a(64, idur, 96)*igrind, .35

irvt		init 1/icps
a1		comb af, line:k(idur/4, idur, idur/2)*4, irvt

a1		flanger pdhalf(a1, cosseg(.85, idur, -.85)), idur/(12+(2*table3:a(line:a(0, idur, 1), ienv, 1)))*igrind, .85
a1		flanger pdhalf(a1, cosseg(-.85, idur/2, .35, idur/2, -.75)), idur/(48+(12*table3:a(line:a(1, idur, 0), ienv, 1)))*igrind, .25

a2		comb a1, line:k(idur/2, idur, idur/24)*8, irvt*2
a3		comb a1, line:k(idur/4, idur, idur/12)*12, irvt*3

aout		= a1 + (a2/2) + (a3/4)
aout		*= (20/icps)*1.5
aout		*= .65 + abs(lfo(.35, 3/idur))

aout		dcblock2 aout

	$END_INSTR
