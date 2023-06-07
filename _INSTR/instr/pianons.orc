	instr piano_load

ipiano   sfload "/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/soundfonts/piano.sf2"
	sfpassign 0, ipiano
	turnoff

	endin
	schedule "piano_load", 0, 1


	$START_INSTR(pianons)

ain		sfplay3m 1, ftom:i(A4), $dyn_var/2048, icps, 0, 1

kestfrq = icps*(ich+1)
kmaxvar = 0.75
imode   = 1
iminfrq = 95
iprd    = 0.005
  
amain		harmon ain, kestfrq, kmaxvar, kestfrq*.5, kestfrq*int(random:i(2, 8)), imode, iminfrq, iprd

k2		expseg icps/2, p3, icps*int(random:i(2, 8))
a2		exciter amain, k2, icps, 10, 1.5

aout		= a2;amain*cosseg(0, p3/2, 1, p3/2, 0) + a1 + a2

	$dur_var(10)
	$END_INSTR
