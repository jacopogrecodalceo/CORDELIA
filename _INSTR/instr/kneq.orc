	$start_instr(kneq)


a1		oscili $dyn_var, icps, gisquare
a2		vco2 $dyn_var, icps*expseg(11/10, p3, 3/4)		
a3		vco2 $dyn_var, icps*expseg(3/2, p3, 3)

idurcos		init (((icps/6)/icps)*idur)
kndx		cosseg 0, idurcos, 1/icps, idurcos, (icps/2)/icps, idurcos, 0, idurcos, (icps/3)/icps, idurcos, 0
a4		vco2 $dyn_var, icps*tab:k(kndx, i(gktuning), 1)

ain		= (a1 + a2 + a3)/2 + a4*2

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

	$dur_var(10)
	$end_instr
