	instr careless

Sinstr		init "careless"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7

anoi		fractalnoise $ampvar, 1

kbw 		= icps/expseg(500, idur, 75) 	;bandwidth in Hz

ain		resony anoi, icps, kbw, 16, 16
ain		balance2 ain, anoi

kharm		init 0
kline		line 1, idur, 11
ieach		init (ich%2)

if int(kline)%2 == ieach then

	kharm int kline

endif

if kharm == 0 then
	kharm = 1
endif

ao1		oscili $ampvar, icps*(3/kharm), gitri
ao2		oscili $ampvar, icps*(3/int(line(11, idur*random:i(.85, 1.25), 1))), gitri

aosc		= ao1 + ao2

across 		cross2 ain, aosc, 1024, 8, gihan, .65

aout		= across

idiff		init 2

aout		*= 1/idiff+((abs(lfo(1/idiff, 1.15+random:i(-.05, .05))))*cosseg(0, idur/2, 1))

;	ENVELOPE
ienvvar		init idur/10

		$death
	endin
