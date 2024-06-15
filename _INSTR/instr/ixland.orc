	$start_instr(ixland)
	
ipanfreq	random -.25, .25

ifn		init 0

ichoose[]	fillarray 1, 3
imeth		init ichoose[int(random(0, lenarray(ichoose)))]

ap		pluck $dyn_var, icps + randomi:k(-ipanfreq, ipanfreq, 1/idur), icps, ifn, imeth

;		RESONANCE

ap_res1		pluck $dyn_var, (icps*4) + randomi:k(-ipanfreq, ipanfreq, 1/idur), icps, ifn, imeth
ap_res2		pluck $dyn_var, (icps*6) + randomi:k(-ipanfreq, ipanfreq, 1/idur), icps, ifn, imeth
ap_res3		pluck $dyn_var, (icps*7) + randomi:k(-ipanfreq, ipanfreq, 1/idur), icps, ifn, imeth

ap_resum	= ap_res1 + ap_res2 + ap_res3

ao_res1		oscil3 $dyn_var, icps, gitri
ao_res2		oscil3 $dyn_var, icps*3, gisine
ao_res3		oscil3 $dyn_var, icps*5, gitri
ao_res4		oscil3 $dyn_var, icps+(icps*21/9), gitri

ao_resum	= ao_res1 + ao_res2 + (ao_res3/4) + (ao_res4/6)

;		REVERB

irvt		init idur/24
arev		reverb (ap_resum/4)+(ao_resum/8), irvt

ivib[]		fillarray .5, 1, 2, 3
ivibt		init ivib[int(random(0, lenarray(ivib)))]

arev		*= 1-(oscil:k(1, gkbeatf*(ivibt+random:i(-.05, 05)), giasine)*cosseg(0, idur*.95, 1, idur*.05, 1))

aout		= ap + arev	
aout		dcblock2 aout

	$dur_var(10)
	$end_instr
