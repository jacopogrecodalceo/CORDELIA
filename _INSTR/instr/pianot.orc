	instr piano_load
ipiano	sfload "/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/soundfonts/piano.sf2"
	sfpassign 0, ipiano
	endin
	schedule "piano_load", 0, 0


	$start_instr(pianot)

	$cps_hi_limit(ntof("8C"))
ituning		i gktuning

ilen		tab_i 0, ituning
ioff		init 4
itun_len	init ilen - ioff

imode			init 0
iminfreq 		init 95
ianal_period		init 25$ms

a1		sfplay3m 1, ftom:i(A4), $dyn_var/2048, icps, 0, 1

a2		oscil3 $dyn_var, portk(icps*int(1+abs(jitter(4, gkbeatf/4, gkbeatf*12))), ianal_period), gisaw
a2		*= .5 + lfo:a(.5, 3/idur)

kndx0		= int((abs(jitter(1, gibeatf/16, gibeatf/8)))*(itun_len+1))
kgenfreq0	limit icps * tab:k(kndx0+ioff, ituning), 20, 15$k

a2		skf a2, kgenfreq0, jitter(3, gkbeatf/16, gkbeatf/8)

asum		= a1 + a2
;kestfreq = icps + jitter(1, gkbeatf/8, gkbeatf)*(icps*11/10)


kndx1		= int((abs(jitter(1, gibeatf/16, gibeatf/8)))*(itun_len+1))
kndx2		= int((abs(jitter(1, gibeatf/16, gibeatf/8)))*(itun_len+1))

;kgenfreq1	limit icps * tab:k(kndx1+ioff, ituning), iminfreq*2, 15$k
;kgenfreq2	limit icps * tab:k(kndx2+ioff, ituning), iminfreq*2, 15$k

kgenfreq1	tab kndx1+ioff, ituning
kgenfreq2	tab kndx2+ioff, ituning

kmaxvar 	= .5+abs(jitter(.5, gibeatf/8, gibeatf))
  
aout		harmon asum, icps, kmaxvar, kgenfreq1, kgenfreq2, imode, iminfreq, ianal_period
aout		/= 4
aout		dcblock2 aout

	$dur_var(10)
	$end_instr
