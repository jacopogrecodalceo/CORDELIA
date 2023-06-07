	instr piano_load

ipiano   sfload "/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/soundfonts/piano.sf2"
	sfpassign 0, ipiano
	turnoff

	endin
	schedule "piano_load", 0, 1


	$START_INSTR(pianon2)

ain		sfplay3m 1, ftom:i(A4), $dyn_var/2048, icps, 0, 1

kestfrq = icps*2
kmaxvar = 0.95
imode   = 1
iminfrq = 95
iprd    = 0.005
  
amain		harmon ain, kestfrq, kmaxvar, kestfrq*.5, kestfrq*int(random:i(2, 8)), imode, iminfrq, iprd

k1		expseg icps/2, p3, icps*4
a1		exciter amain, k1, 15000, 10, 3.5-($dyn_var*5)


k1		line           1.0, p3, 0.0
k2		line           -0.5, p3, 0.0
k3		line           -0.333, p3, -1.0
k4		line           0.0, p3, 0.5
k5		line           0.0, p3, 0.7
k6		line           0.0, p3, -1.0
a2		chebyshevpoly  amain, 0, k1, k2, k3, k4, k5, k6

aout		= a1 + a2*abs:a(lfo:a(expseg(1, p3, .005), cosseg(6, p3, 2)/p3))

aout		/= 4

	$dur_var(10)
	$END_INSTR
