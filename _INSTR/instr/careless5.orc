	$start_instr(careless5)


anoi		fractalnoise $dyn_var, 1

kbw 		= icps/expseg(500, idur, 375) 	;bandwidth in Hz

ain		resony anoi, icps*2, kbw, 8, 24
ain		balance2 ain, anoi

kharm		init 0
klinseg		linseg 1, idur, 11
ieach		init (ich%2)

if int(klinseg)%2 == ieach then
	kharm int klinseg
endif

ao1		oscili $dyn_var, icps*(divz(3, kharm, 1)), gitri
ao2		oscili $dyn_var, icps*(3/int(linseg(11, idur*random:i(.85, 1.25), 1))), gitri

aosc		= ao1 + ao2

across 		cross2 ain, aosc, 512, 4, gihanning, .55

aout		= across + ain/32 + (aosc*cosseg(0, idur, 1))

iost_val[]	fillarray .5, 1, 2, .5, 1, 2, int(random:i(2, 4))
kost_index	init 0
kost_freq_m	= gkbeatf*3*cosseg:k(1, idur, random:i(.95, 1.05))
if metro2:k(kost_freq_m, cosseg(.5, idur, .55)) == 1 then
	kost_index += 1
endif

kost_freq =  iost_val[kost_index%lenarray:i(iost_val)]*icps+random:i(-.05, .05) 

;kost_fact	cosseg 3, idur, 3/2
;iost_dur	init i(gkbeats)
aost_out	oscil3 $dyn_var/cosseg(1, idur, 2), portk(kost_freq, gkbeats/cosseg(48, idur, 24)), gitri

;kost_trig	metro2 gkbeatf*kost_fact, .15
;kost_env	triglinseg kost_trig, 1, iost_dur/iost_fact, 0

aout		+= bob(aost_out, icps*3, .5, .95)

idiff		init 12

klfo		abs lfo(1/idiff, 1.15+random:i(-.05, .05))
aout		*= 1/(idiff+.05+(klfo*cosseg(0, idur/2, 1)))

	$dur_var(10)
	$end_instr
