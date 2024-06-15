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
idyn		init p4
ienv		init p5
icps		init p6
ich		init p7

indx	init 0
until indx == gimetal_max_series do
	schedule Sinstr, 0, idur, idyn, ienv, icps*gimetal_metallic_harmonic_series[indx], ich
	indx += 1
od
	turnoff

	

	instr metal_instr

Sinstr		init "metal"
idur		init p3
idyn		init p4
ienv		init p5
icps		init p6
ich		init p7

$dur_var(10)

aosc		oscil3 $dyn_var/gimetal_max_series*2, icps, gisaw

aosc		*= envgen(idur/2-random:i(0, ienvvar), ienv)

arev1		nreverb aosc/8, idur, $dyn_var

imaxlpt		init idur
krvt		= idur
klpt		= 1/icps
arev2		valpass aosc, krvt, klpt, imaxlpt

aout		= aosc + arev1 + arev2

	$end_instr

	
