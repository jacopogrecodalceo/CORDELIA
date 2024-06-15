	instr pianoch_load
istartindex		init 0
imsg			init 0 ; if non-zero messages are suppressed.
ipiano			sfload "/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/soundfonts/Steinway-Chateau.sf2"
	sfpassign istartindex, ipiano, imsg
	endin
	schedule "pianoch_load", 0, 0

	$start_instr(pianoch)
	$cps_hi_limit(ntof("8C"))

ivel			init 1
ipreset_index	init 37
iflag			init 1 ; when iflag = 1, xfreq is the absolute frequency of the output sound, in Hz

aout		sfplay3m ivel, ftom:i(A4), $dyn_var/2048, icps, ipreset_index, iflag

	$dur_var(10)
	$end_instr
