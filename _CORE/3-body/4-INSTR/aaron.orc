;a sweet sound with a tiny, harsh attack

gkaaron_mod	init 1 ;mod parameter for aaron instr
gkaaron_indx	init 3 ;index parameter for aaron instr
gkaaron_detune	init 0 ;detune parameter for aaron instr

giaaron_atk		init .0095

	instr aaron_instr_1

Sinstr		init "aaron"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich			init p7

//

indx		init i(gkaaron_indx)
idetune 	init i(gkaaron_detune)

//

ivibdiv		random 4, 8

amp		= abs(lfo:a($ampvar, cosseg(random:i(idur*.35, idur*.95)/ivibdiv, idur, random:i(idur*.75, idur*3.5)/ivibdiv)))

//

kcar 	= 1
kmod 	= gkaaron_mod
kndx	= expseg:k(indx, idur, .05)

kcps	= icps + vibr(expseg(.05, idur, icps/(icps*12)), randomi:k(idur*3, idur*5, icps/(icps*12)), gisine)

aout	foscili amp, kcps+randomi:k(-.05, .05, 1/idur, 2, 0), kcar, kmod+randomi:k(-.0015, .0015, 1/idur, 2, 0), kndx+randomi:k(-.05, .05, 1/idur), gisine

;	ENVELOPE
ienvvar		init idur/100

		$death

	endin

	instr aaron_instr_2

Sinstr	init "aaron"

//

irel	init .015

p3		init giaaron_atk + irel
idur 	init p3
iamp 	init p4
icps 	init p6
ich		init p7

ipanfreq	init random:i(-.95, .95)

aout	repluck random:i(.015, .35), iamp, icps + random:i(-ipanfreq, ipanfreq), randomh:k(.25, .95, random:i(.05, .15)), random:i(.05, .65), oscil3:a(1, random:i(.05, .25),  gitri)
aout	dcblock2 aout

aout	*= cosseg(0, giaaron_atk, 1, irel, 0)

	$mix

	endin

	instr aaron_instr_3

Sinstr	init "aaron"

//

idur 	init p3
iamp 	init p4
icps 	init p6
ich	init p7

ipanfreq	= random:i(-.95, .95)

//

aout	repluck random:i(.015, .35), $ampvar, icps + random:i(-ipanfreq, ipanfreq), randomh:k(.25, .95, random:i(.05, .15)), random:i(.05, .65), oscil3:a(1, random:i(.05, .25), gisine)
aout	dcblock2 aout

aout	*= cosseg(0, giaaron_atk, 1, idur/5, 0)

	$mix

	endin

	instr aaron_instr_4

Sinstr	= "aaron"

//

idur 	init p3 / 3
iamp	init p4
amp		= abs(lfo:a(iamp, cosseg(random:i(idur*.5, idur*.75)/2, idur, random:i(idur*.75, idur*3.5)/2)))

icps 	init p6
ich		init p7
//

af		fractalnoise random:i(.05, .75), random:i(.05, .75)

kcps	= icps + vibr(expseg(.05, idur, icps/(icps*12)), randomi:k(idur*3, idur*5, icps/(icps*12)), gisine)

arout	resonx	af, kcps, icps/5

aout	balance arout, af

aout	*= amp

aout	*= cosseg(0, giaaron_atk, iamp, idur, 0)

	$mix

	endin

;---

	instr aaron

Sinstr		init "aaron"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7

indx		init i(gkaaron_indx)
idetune 	init i(gkaaron_detune)

	event "i", sprintf("%s_instr_1", Sinstr), 0,	idur, iamp,		iftenv, icps, ich

	event "i", sprintf("%s_instr_2", Sinstr), 0,	idur, iamp/6,	iftenv, icps+idetune, ich
	event "i", sprintf("%s_instr_3", Sinstr), 0,	idur, iamp/6,	iftenv, icps+idetune, ich

	event "i", sprintf("%s_instr_2", Sinstr), 0,	idur, iamp/3,	iftenv, icps*2.11+idetune, ich
	event "i", sprintf("%s_instr_3", Sinstr), 0,	idur, iamp/3,	iftenv, icps*1.97+idetune, ich

	event "i", sprintf("%s_instr_4", Sinstr), 0,	idur, iamp/5,	iftenv, icps, ich

	turnoff

	endin
