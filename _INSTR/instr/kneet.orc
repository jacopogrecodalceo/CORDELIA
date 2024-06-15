	$start_instr(kneet)


a1			oscili $dyn_var, icps, gisquare
a2			vco2 $dyn_var, icps*expseg(11/10, p3, 3/4)		
a3			vco2 $dyn_var, icps*expseg(3/2, p3, 3)

kndx		= abs(jitter(1, gibeatf/8, gibeatf))

ituning		i gktuning
ilen		tab_i 0, ituning
ioff		init 4
itun_len	init ilen - ioff

ktun_dec	tab (kndx*(itun_len+1))+ioff, ituning

a4			vco2 $dyn_var, icps*ktun_dec

ain			= (a1 + a2 + a3)/2 + a4*2

k1 = 1 - jitter(2, gibeatf/8, gibeatf)
k2 = 1 - jitter(2, gibeatf/8, gibeatf)
k3 = 1 - jitter(2, gibeatf/8, gibeatf)
k4 = 1 - jitter(2, gibeatf/8, gibeatf)
k5 = 1 - jitter(2, gibeatf/8, gibeatf)
k6 = 1 - jitter(2, gibeatf/8, gibeatf)
k7 = 1 - jitter(2, gibeatf/8, gibeatf)

acheb		chebyshevpoly  ain, 0, k1, k2, k3, k4, k5, k6, k7

abal		balance2 acheb, ain

ilpt		init 1/icps
krvt		cosseg idur/12, idur, idur
acomb		comb abal, krvt, ilpt

icps_limit	= icps/2

if icps_limit > 20 then
	acomb	+= oscili($dyn_var, icps_limit, gisine)
else
	acomb	+= oscili($dyn_var, icps*2, gisine)
endif

aout		= acomb
aout		/= 160
aout		dcblock2 aout
	$dur_var(10)
	$end_instr
