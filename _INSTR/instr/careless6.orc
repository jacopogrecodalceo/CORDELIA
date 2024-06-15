	$start_instr(careless6)

anoi		fractalnoise $dyn_var, 1

kbw 		= icps/expseg(450, idur, 35) 	;bandwidth in Hz

ain		resony anoi, icps*2, kbw, 8, 8
ain		balance2 ain, anoi

kharm		init 0
kjit1		= 11 + jitter(5.25, gkbeatf/8, gkbeatf)
kjit2		= 11 + jitter(5.25, gkbeatf/8, gkbeatf)
ieach		init (ich%2)

if int(kjit1)%2 == ieach then
	kharm int kjit1
endif

ao1		oscili $dyn_var, icps*(divz(3, kharm, 1)), gitri
ao2		oscili $dyn_var, icps*(3/kjit2), gitri

aosc		= ao1 + ao2

across 		cross2 ain, aosc, 512, 4, gihanning, .55

aout		= across + ain/32 + (aosc*cosseg(.5, idur, 1))

iost_val[]	fillarray .5, 1, 4, .5, 3, 2, int(random:i(2, 4))
ilen_arr	lenarray iost_val
ilen_arr	init ilen_arr-1
kost_index	= ilen_arr * (jitter(.5, gkbeatf/8, gkbeatf*16)*cosseg(0, idur/2, 1))
kost_freq_m	= gkbeatf*3*cosseg:k(1, idur, random:i(.95, 1.05))

kost_freq =  iost_val[kost_index]*icps+jitter(icps/100, gkbeatf/8, gkbeatf)

;kost_fact	cosseg 3, idur, 3/2
;iost_dur	init i(gkbeats)
aost_out	oscil3 $dyn_var/cosseg(1, idur, 2), portk(kost_freq, gkbeats/cosseg(48, idur, 24)), gitri

;kost_trig	metro2 gkbeatf*kost_fact, .15
;kost_env	triglinseg kost_trig, 1, iost_dur/iost_fact, 0

aout		+= bob(aost_out, icps*8, .5, .95)

idiff		init 12

klfo		abs lfo(1/idiff, 1.15+random:i(-.05, .05))
aout		*= 1/(idiff+.05+(klfo*cosseg(0, idur/2, 1)))

	$dur_var(10)
	$end_instr
