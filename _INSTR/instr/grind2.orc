gkgrind2_p1	init 1

	$start_instr(grind2)
	$dur_var(10)

igrind		i gkgrind2_p1

aex		fractalnoise $dyn_var, cosseg(1, idur, 0)
;aex		*= cosseg(0, 5$ms, $dyn_var, 5$ms, 0)
aex		*= cosseg(0, idur/128, $dyn_var, idur/256, 0)

af		flanger aex/3, idur/cosseg:a(64, idur, 96)*igrind, .35

irvt		init 1/icps
a1		comb af, line:k(idur/4, idur, idur/2)*4, irvt

if ienv > 0 then
	istart	init 0
	iend	init 1
else
	istart	init 1
	iend	init 0
endif
ienv_abs	abs ienv

a1		flanger pdhalf(a1, cosseg(.85, idur, -.85)), idur/(12+(2*table3:a(line:a(istart, idur, iend), ienv_abs, 1)))*igrind, .85
a1		flanger pdhalf(a1, cosseg(-.85, idur/2, .35, idur/2, -.75)), idur/(48+(12*table3:a(line:a(iend, idur, istart), ienv_abs, 1)))*igrind, .25

a2		comb a1, line:k(idur/2, idur, idur/24)*8, irvt*2
a3		comb a1, line:k(idur/4, idur, idur/12)*12, irvt*3

aout		= a1 + (a2/2) + (a3/4)
aout		*= (20/icps)*1.5
aout		*= .65 + abs(lfo(.35, 3/idur))

aout		dcblock2 aout

	$end_instr
