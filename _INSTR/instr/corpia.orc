	$start_instr(corpia)
	$cps_hi_limit(ntof("8C")) ;limit cps to the last note of the piano

idyn	init idyn/3

idur	init idur

ifreq 	init icps			;base frequency of the string.
iNS	init 2				;the number of strings involved. In a real piano 1, 2 or 3 strings are found in different frequency regions.
iD	random 1.5, 3.5				;the amount each string other that the first is detuned from the main frequency, measured in cents.
iK	init 1-$dyn_var			;dimensionless stiffness parameter.
iT30	init idur*4			;30db decay time in seconds.
ib 	limit .15-($dyn_var*.15), 0, 1	;high-frequency loss parameter (keep this small).
kbcl 	init 3				;boundary condition at left end of string (1 is clamped, 2 pivoting and 3 free).
kbcr	init 3				;boundary condition at right end of string (1 is clamped, 2 pivoting and 3 free).
imass 	init 1.95			;the mass of the piano hammer.
ihvfreq init 9				;the frequency of the natural vibrations of the hammer.
iinit	init 7-($dyn_var*4)		;the initial position of the hammer.
ipos	init .15+($dyn_var*.05)			;position along the string that the strike occurs.
ivel	init .15				;normalized strike velocity.
isfreq	init .05			;scanning frequency of the reading place.
ispread init 2				;scanning frequency spread.

apia			prepiano ifreq, iNS, iD, iK, \
   				 iT30, ib, kbcl, kbcr, imass, ihvfreq, iinit, ipos, ivel, isfreq, \
				 ispread

a1			repluck .15, 1, icps*1, .75, 1-$dyn_var, apia
a2			repluck .5, 1, icps*2, .95, 1-$dyn_var, apia
a3			repluck .95, 1, icps*3, .15, 1-$dyn_var, apia

aout			= apia + (a1 + a2 + a3)*.85
aout			*= ($dyn_var)/7

aout			skf aout, icps*cosseg(13, idur, 3), 2.15+$dyn_var
aout			limit aout, -1, 1
aout			dcblock2 aout
	$dur_var(10)

	$end_instr

