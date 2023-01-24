gimetal_max_series init 9
gimetal_metallic_harmonic_series[] init gimetal_max_series

indx 	init 0
until indx == gimetal_max_series do
	gimetal_metallic_harmonic_series[indx] = (indx + sqrt(indx^2 + 4))/2
	indx += 1
od

	instr metal

Sinstr		init "metal_instr"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7

indx	init 0
until indx == gimetal_max_series do
	schedule Sinstr, 0, idur, iamp, iftenv, icps*gimetal_metallic_harmonic_series[indx], ich
	indx += 1
od
	turnoff

	endin

	instr metal_instr

Sinstr		init "metal"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7

ienvvar		init idur/10

aosc		oscil3 $ampvar/gimetal_max_series*2, icps, gisaw

aosc		*= envgen(idur/2-random:i(0, ienvvar), iftenv)

arev1		nreverb aosc/8, idur, $ampvar

imaxlpt		init idur
krvt		= idur
klpt		= 1/icps
arev2		valpass aosc, krvt, klpt, imaxlpt

aout		= aosc + arev1 + arev2

	$death

	endin
