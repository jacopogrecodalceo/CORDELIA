	instr piano_load

ipiano   sfload "/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/soundfonts/piano.sf2"
	sfpassign 0, ipiano
	endin

	
	schedule "piano_load", 0, 0


	$start_instr(pianons2)
	$cps_hi_limit(ntof("8C"))

ain		sfplay3m 1, ftom:i(A4), $dyn_var/2048, icps, 0, 1


iestfreq = (icps*2)*pow(2, int(random:i(1, 4)))
if iestfreq > 15$k then
	iestfreq = icps*2
endif


kmaxvar = 0.75
imode   = 1
iminfreq = 95
iprd    = 0.005
  
amain		harmon ain, icps*2, kmaxvar, icps, iestfreq, imode, iminfreq, iprd

k2		expseg icps/2, p3, icps*pow(2, int(random:i(1, 4)))
a2		exciter amain, k2, icps, 10, 1.5

aout		= a2;amain*cosseg(0, p3/2, 1, p3/2, 0) + a1 + a2

	$dur_var(10)
	$end_instr
