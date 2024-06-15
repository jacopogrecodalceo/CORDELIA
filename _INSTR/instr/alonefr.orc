if active(nstrnum("alonefr_instr"))>0 then
	turnoff2 "alonefr_instr", 0, 0
endif


if active(nstrnum("alone"))>0 then
	turnoff2 "alone", 0, 0
endif

maxalloc "alonefr_instr", nchnls
maxalloc "alonefr", nchnls*4

gkalonefr_env init 0
gkalonefr_cps init 20

gialonefr_count init 1
gkalonefr_env	init 0


	instr alonefr

idur		init p3
idyn		init p4/2
ienv		init p5
icps		init p6
ich			init p7


if ich == 1 then
	gkalonefr_dur	portk idur, 5$ms

	gkalonefr_env = envgen(idur, ienv)*$dyn_var

	gkalonefr_cps init icps

	gkalonefr_harm init gialonefr_count
	gialonefr_count += 1

	if gialonefr_count == 4 then
		gialonefr_count init 1
	endif

endif

	

	instr alonefr_instr

Sinstr		init "alonefr"
ich		init p4

kharm		int abs(lfo(9, gkalonefr_harm/gkalonefr_dur))
kharm		+= 3/2

kdyn		= portk(gkalonefr_env, 35$ms, 0)
kfreq		= portk(gkalonefr_cps*gkalonefr_harm, limit(gkalonefr_dur/1000, 75$ms, 1))+randomi:k(-gkalonefr_cps/1000, gkalonefr_cps/1000, 1/gkalonefr_dur)
avco1		oscil3 kdyn, kfreq, gisaw
avco2		oscil3 kdyn, kfreq*kharm, gitri
avco3		oscil3 kdyn, kfreq*kharm/2, gisine

avco		= avco1 + avco2 + avco3

adel		= gkalonefr_dur/(kharm)
kfb		= (1-gkalonefr_env)*.25
adel		flanger avco, adel*gkalonefr_harm, kfb

amoog		moogladder2 adel, gkalonefr_cps+(gkalonefr_cps*portk((1-gkalonefr_env)*64, 5$ms)), .5

aout		phaser1 amoog, gkalonefr_cps, 12, gkalonefr_env

	$CHNMIX

	

indx	init 0
until	indx == nchnls do
	schedule nstrnum("alonefr_instr")+(indx/1000), 0, -1, indx+1
	indx	+= 1
od


