gksufij2_p1	init 64
gksufij2_p2	init 1
gksufij2_p3	init 32

	instr sufij2

Sinstr		init "sufij2"
idur		init p3
idyn		init p4
ienv		init p5
icps		init p6
ich		init p7

kdiv1		= gksufij2_p3
kdiv2		= kdiv1/5

anoi		fractalnoise $dyn_var*cosseg(1, idur, 0)*metro:k(kdiv1/idur), cosseg:k(0, idur, 2)
aback		fractalnoise $dyn_var*metro:k(kdiv2/idur), cosseg:k(2, idur, 0)		
abackagain	fractalnoise $dyn_var*linseg(1, idur, 0), cosseg:k(0, idur, 2)		

anoibacksum	= anoi + aback + (abackagain/8)

anoif		flanger anoibacksum, a(idur/expseg(12, idur, i(gksufij2_p3))), .95

anoisum		= anoi + anoif

inum		i gksufij2_p1				;num of filters
kbf 		cosseg icps*2, idur/24, icps*.5, idur/24, icps, idur*(22/24), icps+random:i(-icps/100, icps/100)				;base frequency, i.e. center frequency of lowest filter in Hz
kbw 		= icps/expseg(95, idur, 350) 	;bandwidth in Hz
ksep 		int cosseg(14, idur, 16)+i(gksufij2_p2)				;separation of the center frequency of filters in octaves

idiff		i gksufij2_p3

aout		resony anoisum, kbf, kbw, inum+random:i(-inum/idiff, inum/idiff), ksep
aout		balance2 aout, anoi

;aout		*= .5 + (tablei:a(phasor:a(gkbeatf*2), gihsine, 1)*cosseg(0, idur/8, .5))

$dur_var(10)

	$end_instr

	
