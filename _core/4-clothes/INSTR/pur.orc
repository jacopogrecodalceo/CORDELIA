	instr pur

Sinstr		init "pur"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7

ipanfreq	random -.25, .25

ifn		init iftenv
imeth		init 6

a1		pluck 1, (icps*(1-ich%2)+1) + randomi:k(-ipanfreq, ipanfreq, 1/idur), icps, ifn, imeth
a2		pluck 1, (icps*(ich%2)+1) + randomi:k(-ipanfreq, ipanfreq, 1/idur), icps, ifn, imeth

arig1		oscili 1, icps/3	
arig2		oscili 1, icps*3/2	

igain		init .5 ;gain regulation

aout		= igain*(a1 + a2)*arig1*arig2*$ampvar

aout		flanger aout, cosseg:a(idur/128, idur, idur/96), cosseg(.35, idur, 1-$ampvar)
aout		bqrez	aout, icps+(icps*(32*$ampvar)), cosseg(.95, idur/2, .5)

ienvvar		init idur/10

	$death

	endin
