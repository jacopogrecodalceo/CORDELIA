if active(nstrnum("ventre_instr"))>0 then
	turnoff2 "ventre_instr", 0, 0
endif


if active(nstrnum("alone"))>0 then
	turnoff2 "alone", 0, 0
endif

maxalloc "ventre_instr", nchnls
maxalloc "ventre", nchnls*4

gkventre_env init 0
gkventre_cps init 20

giventre_count init 1
gkventre_env	init 0

gkventre_lad	init 4000

	instr ventre

idur		init p3
iamp		init p4/2
iftenv		init p5
icps		init p6
ich			init p7


if ich == 1 then
	gkventre_dur	portk idur, 5$ms

	gkventre_env = envgen(idur, iftenv)*$ampvar

	gkventre_cps init icps

	gkventre_harm init giventre_count
	giventre_count += 1

	if giventre_count == 4 then
		giventre_count init 1
	endif

endif

	endin

	instr ventre_instr

Sinstr		init "ventre"
ich		init p4

kharm		int abs(lfo(9, gkventre_harm/gkventre_dur))
kharm		+= 3/2

kamp		= portk(gkventre_env, 35$ms, 0)
kfreq		= portk(gkventre_cps*gkventre_harm, limit(gkventre_dur/1000, 75$ms, 1))+randomi:k(-gkventre_cps/1000, gkventre_cps/1000, 1/gkventre_dur)
avco1		oscil3 kamp, kfreq, gisaw
avco2		oscil3 kamp, kfreq*kharm, gitri
avco3		oscil3 kamp, kfreq*kharm/2, gisine

avco		= avco1 + avco2 + avco3

adel		= gkventre_dur/(kharm)
kfb		= (1-gkventre_env)*.25
adel		flanger avco, adel*gkventre_harm, kfb

amoog		moogladder2 adel, gkventre_cps+(gkventre_cps*portk((1-gkventre_env)*64, 5$ms)), .5

aphas		phaser1 amoog, gkventre_cps, 12, gkventre_env

aout		moogladder2 aphas, gkventre_lad, .95
aout		balance2 aout, aphas
	$mix

	endin

indx	init 0
until	indx == nchnls do
	schedule nstrnum("ventre_instr")+(indx/1000), 0, -1, indx+1
	indx	+= 1
od


