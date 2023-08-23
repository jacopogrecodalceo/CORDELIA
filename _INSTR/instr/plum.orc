
giplum_freqs1[] fillarray 1, 3, 1, 3, 2, 4, 1

giplum_freqs2[] fillarray 1, 2, 3

	instr plum

	$params

icpsvar		init abs((icps-(icps*11/10))/6)

kfreq1		int cosseg(0, idur/2, lenarray(giplum_freqs1)-1, idur/2, 0)

a1		oscil3 $dyn_var, giplum_freqs1[kfreq1]*icps+random:i(-icpsvar, icpsvar), gisine

knh		= 3+oscil3(9, icpsvar/10)
klh		cosseg 1, idur, 3
kmul		cosseg 0, idur, .95


kfreq2		int cosseg(0, idur, lenarray(giplum_freqs2))
a2		gbuzz $dyn_var, giplum_freqs2[kfreq2]*icps+random:i(-icpsvar, icpsvar), knh, klh, kmul, gitri

aout 		= a1 + a2
aout		/= 3

$dur_var(10)

	$end_instr

	
