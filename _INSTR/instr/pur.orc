	$start_instr(pur)

ipanfreq	random -.25, .25

ifn		init ienv
imeth		init 6

a1		pluck 1, (icps*(1-ich%2)+1) + randomi:k(-ipanfreq, ipanfreq, 1/idur), icps, ifn, imeth
a2		pluck 1, (icps*(ich%2)+1) + randomi:k(-ipanfreq, ipanfreq, 1/idur), icps, ifn, imeth

arig1		oscili 1, icps/3	
arig2		oscili 1, icps*3/2	

igain		init .5 ;gain regulation

aout		= igain*(a1 + a2)*arig1*arig2*$dyn_var

aout		flanger aout, cosseg:a(idur/128, idur, idur/96), cosseg(.35, idur, 1-$dyn_var)
aout		bqrez	aout, icps+(icps*(32*$dyn_var)), cosseg(.95, idur/2, .5)

	$dur_var(10)
	$end_instr

