	$start_instr(careless2)

anoi		fractalnoise $dyn_var, 1

kbw 		= icps/expseg(500, idur, 75) 	; bandwidth in Hz

ain			resony anoi, icps, kbw, 16, 16
ain			balance2 ain, anoi

kharm		init 0
klinseg		linseg 1, idur, 11
ieach		init ich%2

if int(klinseg)%2 == ieach then
	kharm int klinseg
endif

ao1			oscili $dyn_var, icps*(divz(3, kharm, 1)), gitri
ao2			oscili $dyn_var, icps*(3/int(linseg(11, idur*random:i(.85, 1.25), 1))), gitri

aosc		= ao1 + ao2

across 		cross2 ain, aosc, 1024, 8, gihanning, .65

aout		= across + ain + (aosc*cosseg(0, idur, 1))

idiff		init 12

klfo		abs lfo(1/idiff, 1.15+random:i(-.05, .05))
aout		*= 1/(idiff+.05+(klfo*cosseg(0, idur/2, 1)))

	$dur_var(10)
	$end_instr
