	$START_INSTR(careless3)

anoi		fractalnoise $dyn_var, 1

kbw 		= icps/expseg(500, idur, 75) 	;bandwidth in Hz


kost_val[]	fillarray .5, 1, 2, .5, 1, 2, int(random:i(2, 4))
kost_index	init 0
kost_freq_m	= gkbeatf*3*cosseg:k(1, idur, random:i(.95, 1.05))
if metro2:k(kost_freq_m, cosseg(.5, idur, .55)) == 1 then
	kost_index += 1
endif

kost_freq =  kost_val[kost_index%lenarray(kost_val)]*icps+random:i(-.05, .05) 

;kost_fact	cosseg 3, idur, 3/2
;iost_dur	init i(gkbeats)
aost_out	oscil3 $dyn_var, portk(kost_freq, gkbeats/cosseg(48, idur, 24)), gitri

;kost_trig	metro2 gkbeatf*kost_fact, .15
;kost_env	triglinseg kost_trig, 1, iost_dur/iost_fact, 0

anoi		+= aost_out*cosseg(0, idur, 1)

ain		resony anoi, icps, kbw, 8, 16
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

ao1		oscili $dyn_var, icps*(3/kharm), gitri
ao2		oscili $dyn_var, icps*(3/int(line(11, idur*random:i(.85, 1.25), 1))), gitri

aosc		= ao1 + ao2

across 		cross2 ain, aosc, 1024, 8, gihanning, .65

aout		= across + ain + (aosc*cosseg(0, idur, 1))

idiff		init 12
aout		*= 1/idiff+((abs(lfo(1/idiff, 1.15+random:i(-.05, .05))))*cosseg(0, idur/2, 1))


	$dur_var(10)
	$END_INSTR

