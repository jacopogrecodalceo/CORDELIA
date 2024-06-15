	instr piano_load

ipiano   sfload "/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/soundfonts/piano.sf2"
	sfpassign 0, ipiano
	endin

	
	schedule "piano_load", 0, 0


	$start_instr(pianons)

ain		sfplay3m 1, ftom:i(A4), $dyn_var/2048, icps, 0, 1

imax_freq	init ntof("7Eb")

until icps < imax_freq do
	icps /= 2
od

iharm_freq = icps*2*int(random:i(2, 8))
until iharm_freq < imax_freq do
	iharm_freq /= 2
od

kmaxvar = 0.75
imode   = 1
iminfreq = 95
iprd    = 0.005
  
amain		harmon ain, icps*2, kmaxvar, icps, iharm_freq, imode, iminfreq, iprd

iexc_freq	init icps*int(random:i(2, 8))
until iexc_freq < imax_freq do
	iexc_freq /= 2
od

k2		expseg icps/2, p3, iexc_freq
a2		exciter amain, k2, icps, 10, 1.5

aout		= a2;amain*cosseg(0, p3/2, 1, p3/2, 0) + a1 + a2

	$dur_var(10)
	$end_instr
