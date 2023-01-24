	instr trans

	$params

ifreq		init (icps*10/8)-icps*((ich%2)+1)
kenvib		cosseg 0, idur*2/3, .125*$ampvar, idur/3, 1
avib		= lfo(ifreq*kenvib+(5*$ampvar), 1/idur)
avib		*= cosseg(1, idur, 0)
aosc		oscil3 $ampvar, (icps+avib)*4, gitri
aosc		*= .5+lfo(.5, cosseg(1.5, idur, 6)/idur)
aosc		flanger aosc, cosseg:a(idur/2, idur/2, idur/3, idur/2, idur/8)/64, cosseg(.15, idur, .95)
;BELL
ivib_arr[]	fillarray 3, 5, 7
ab1		fmbell $ampvar, icps+lfo(icps/100, ivib_arr[random:i(0, lenarray(ivib_arr))]/idur), .105*$ampvar, 0, .5, 2/idur
;END
ijet		init .15+(($ampvar/16))		;Values should be positive, and about 0.3. The useful range is approximately 0.08 to 0.56.
iatk		init idur/9
idec	 	init idur/8
inoise_gain	init $ampvar/8
;kvibf		= (idur/int(random:i(2, 12)))+cosseg(random:i(-ivib, ivib), idur, 0)
kvibf		= 3/idur
kvamp		expseg iamp/3, idur, iamp
aorg1		wgflute $ampvar, icps*2+lfo(icps/100, ivib_arr[random:i(0, lenarray(ivib_arr))]/idur), ijet, iatk, idec, inoise_gain, kvibf, kvamp
aorg2		wgflute $ampvar, icps*3/2, ijet*2, iatk, idec, inoise_gain, kvibf, kvamp
af		moogladder2 aorg1+aorg2, limit(icps*(24*$ampvar*2)+lfo(icps/10, 2*ivib_arr[random:i(0, lenarray(ivib_arr))]/idur), 20, 20$k), $ampvar
;OUT
aout		= aosc/8 + ab1 + af/.75
aout		*= 4

ienvvar		init idur/10

	$death

	endin
