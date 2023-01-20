gkcalinin_vib init 8

	instr calinin

Sinstr		init "calinin"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7

kharm		init 0
kline		linseg 1, idur*21/22, 11, idur/22, 7
ieach		init (ich%2)

if int(kline)%2 == ieach then

	kharm int kline

endif

if kharm == 0 then
	kharm = 1
endif

kbw 		= icps/expseg(500, idur, 75) 	;bandwidth in Hz

kcar	 	= kharm
amod	 	= (3+ich)*$ampvar
kndx		= expseg:k(giexpzero, idur, 1+$ampvar)

ain		foscili $ampvar, icps+randomi:k(-.05, .05, 1/idur, 2, 0)+kbw, kcar, amod+randomi:a(-.015, .015, 1/idur, 2, 0), kndx+randomi:k(-.05, .05, 1/idur), gitri

ao1		oscili $ampvar, icps*(6/kharm), gisine
ao2		oscili $ampvar, icps*(6/int(line(11, idur*random:i(.85, 1.25), 1))), gitri
ao3		oscili $ampvar, limit(icps*(2/kharm), 20, 20$k), gisine

aosc		= ao1 + ao2 + ao3

aout		= (ain*$ampvar) + (aosc*cosseg(0, idur, 1))

kdiff		= gkcalinin_vib

aout		*= 1/kdiff+((abs(lfo(1/kdiff, 4+random:i(-.15, .15))*cosseg(1, idur, .25)))*cosseg(0, idur/2, 1))

;	ENVELOPE
ienvvar		init idur/100

		$death
	endin
