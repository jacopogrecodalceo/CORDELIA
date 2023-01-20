	instr ixland

Sinstr		init "ixland"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7

ipanfreq	random -.25, .25

ifn		init 0

ichoose[]	fillarray 1, 3
imeth		init ichoose[int(random(0, lenarray(ichoose)))]

ap		pluck $ampvar, icps + randomi:k(-ipanfreq, ipanfreq, 1/idur), icps, ifn, imeth

;		RESONANCE

ap_res1		pluck $ampvar, (icps*4) + randomi:k(-ipanfreq, ipanfreq, 1/idur), icps, ifn, imeth
ap_res2		pluck $ampvar, (icps*6) + randomi:k(-ipanfreq, ipanfreq, 1/idur), icps, ifn, imeth
ap_res3		pluck $ampvar, (icps*7) + randomi:k(-ipanfreq, ipanfreq, 1/idur), icps, ifn, imeth

ap_resum	= ap_res1 + ap_res2 + ap_res3

ao_res1		oscil3 $ampvar, icps, gitri
ao_res2		oscil3 $ampvar, icps*3, gisine
ao_res3		oscil3 $ampvar, icps*5, gitri
ao_res4		oscil3 $ampvar, icps+(icps*21/9), gitri

ao_resum	= ao_res1 + ao_res2 + (ao_res3/4) + (ao_res4/6)

;		REVERB

irvt		init idur/24
arev		reverb (ap_resum/4)+(ao_resum/8), irvt

ivib[]		fillarray .5, 1, 2, 3
ivibt		init ivib[int(random(0, lenarray(ivib)))]

arev		*= 1-(oscil:k(1, gkbeatf*(ivibt+random:i(-.05, 05)), giasine)*cosseg(0, idur*.95, 1, idur*.05, 1))

aout		= ap + arev	

ienvvar		init idur/10

	$death

	endin
