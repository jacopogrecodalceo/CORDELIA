	instr cnik

	$params

a1		oscili $ampvar, icps, gisquare
a2		vco2 $ampvar, icps*expseg(3/2, p3, 3/4)		
a3		vco2 $ampvar, icps*expseg(3/2, p3, 3)

ain		= a1 + a2 + a3

ilpt		init 1/icps
krvt		cosseg idur, idur, idur/9
acomb		comb ain, krvt, ilpt

k1		line           0, p3, 0
k1jit		= 1 - jitter(2, gibeatf/4, gibeatf*4)

k2		line           -.5, p3, 0
k3		line           -.35, p3, 1
k4		line           0, p3, .5
k5		line           -.35, p3, .75
k6		line           0, p3, -1
k7jit		= 1 - jitter(2, gibeatf/4, gibeatf*4)

acheb		chebyshevpoly  acomb, 0, k1jit, k2, k3, k4, k5, k6, k7jit

abal		balance2 acheb, ain

icps_limit	= icps/2

if icps_limit > 20 then
	abal	+= oscili($ampvar, icps_limit, gisine)
else
	abal	+= oscili($ampvar, icps*2, gisine)
endif

aout		= abal
aout		/= 6

;		ENVELOPE
ienvvar		init idur/10

	$END_INSTR

	endin
