	instr piano_load

ipiano	sfload "/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/soundfonts/piano.sf2"
	sfpassign 0, ipiano
	endin
	schedule "piano_load", 0, 0

	$start_instr(pianon)
	$cps_hi_limit(ntof("8C"))

ain		sfplay3m 1, ftom:i(A4), $dyn_var/2048, icps, 0, 1

iestfreq = (icps*2)*int(random:i(2, 8))
if iestfreq > 15$k then
	iestfreq = icps*2
endif

kmaxvar = 0.95
imode   = 1
iminfreq = 95
iprd    = 0.005
  
amain	harmon ain, icps*2, kmaxvar, icps, iestfreq, imode, iminfreq, iprd

k2		expseg icps/2, p3, icps*4
a2		exciter amain, k2, 15000, 10, 3.5

;prints("\nMYCPSIS %f\n\n", icps)

aout		= a2;amain*cosseg(0, p3/2, 1, p3/2, 0) + a1 + a2
aout		dcblock2 aout
	$dur_var(10)
	$end_instr
