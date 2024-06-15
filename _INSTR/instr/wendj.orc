	$start_instr(wendj)

;	gendy kdyn, kdyndist, kdurdist, kadpar, kddpar, kminfreq, kmaxfreq, kdynscl, kdurscl [, initcps] [, knum]

kdyndist	init 1
kdurdist	init 0

kadpar		init .995 ;parameter for the kdyndist distribution. Should be in the range of 0.0001 to 1
kddpar		init .45 ;parameter for the kdurdist distribution. Should be in the range of 0.0001 to 1

kvar		expseg icps/75, idur, icps/15

kminfreq	= icps-kvar
kmaxfreq	= icps+kvar

kdynscl		init .95 ;multiplier for the distribution's delta value for amplitude (1.0 is full range)
kdurscl		init .15 ;multiplier for the distribution's delta value for duration

initcps		init 16+(idyn*32)

;		INSTR
ainstr1_out			gendy $dyn_var, kdyndist, kdurdist, kadpar, kddpar, kminfreq, kmaxfreq, kdynscl, kdurscl, initcps

;		INSTR 2
ainstr2_1		oscil $dyn_var, icps*random:i(1.995, 2.005)*2, gisaw
ainstr2_2		oscil $dyn_var, icps*random:i(1.995, 2.005)*4, gisaw

ainstr2_out		= ainstr2_1 + (ainstr2_2/1.75)

iatk		init idur*.05
idec		init idur*.45
isus		init random(.35, .45)
irel		init idur*.5

#define 	wendjvib2 #abs(oscil(1, cosseg(random(.5, 1)/iatk, idur, random(5, 45)/irel), gisine))#

ainstr2_out		= ainstr2_out * linseg(0, iatk, 1, idec, isus, irel, 0) * $wendjvib2

;		INSTR 3
ainstr3_out		oscil $dyn_var, icps*random:i(1.995, 2.005)/2, gitri
ainstr3_out		*= cosseg(1, idur/(3+gauss(.25)), 0)

;		MIX
aout		= ainstr1_out + (ainstr2_out*.65) + (ainstr3_out*1.35)

		;		ENVELOPE
		$dur_var(10)
		$end_instr

	
