gkcalin_vib init 8

	$start_instr(calin)

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
amod	 	= 3+ich
kndx		= expseg:k(giexpzero, idur, 1+$dyn_var)

ain		foscili $dyn_var, icps+randomi:k(-.05, .05, 1/idur, 2, 0)+kbw, kcar, amod+randomi:a(-.015, .015, 1/idur, 2, 0), kndx+randomi:k(-.05, .05, 1/idur), gisine

ao1		oscili $dyn_var, icps*(3/kharm), gitri
ao2		oscili $dyn_var, icps*(3/int(line(11, idur*random:i(.85, 1.25), 1))), gitri

aosc		= ao1 + ao2

across 		cross2 ain, aosc, 1024, 8, gihanning, .5

aout		= across + (ain*$dyn_var) + (aosc*cosseg(0, idur, 1))

kdiff		= gkcalin_vib

aout		*= 1/kdiff+((abs(lfo(1/kdiff, 4+random:i(-.15, .15))*cosseg(1, idur, .25)))*cosseg(0, idur/2, 1))

	$dur_var(100)
	$end_instr
