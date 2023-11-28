maxalloc "alone_instr", nchnls
maxalloc "alone", nchnls*4

gkalone_env init 0
gkalone_cps init 20

gialone_count init 1

	instr alone

Sinstr		init "alone_instr"
idur		init p3
idyn		init p4
ienv		init p5
icps		init p6
ich         init p7

	$dur_var(10)
idyn init idyn*.65

if ich == 1 then

	gkalone_dur	portk idur, 5$ms

	gkalone_env = envgen(idur-random:i(0, idur_var), ienv)*$dyn_var
	gkalone_cps init icps

	gkalone_harm init gialone_count
	gialone_count += 1

	if gialone_count == 9 then
		gialone_count init 1
	endif

endif

	endin



	instr alone_instr

Sinstr		init "alone"
ich			init p4

kharm		int abs(lfo(9, gkalone_harm/gkalone_dur))
kharm		+= 3/2

avco1		vco2 portk(gkalone_env, 5$ms), portk(gkalone_cps, limit(gkalone_dur/1000, 35$ms, 1))+randomi:k(-gkalone_cps/1000, gkalone_cps/1000, 1/gkalone_dur)

avco2		oscil3 portk(gkalone_env, 5$ms), kharm*portk(gkalone_cps, limit(gkalone_dur/1000, 5$ms, 125$ms))+randomi:k(-gkalone_cps/1000, gkalone_cps/1000, 1/gkalone_dur), gitri
avco2		flanger avco2, a(gkalone_dur/9), .75

avco		= avco1 + avco2


aout		moogladder2 avco, gkalone_cps+(gkalone_cps*portk(gkalone_env*64, 5$ms)), .5
aout		phaser1 aout, gkalone_cps/1000, 9, .95
aout		balance2 aout, avco

	$channel_mix
	endin
	

indx	init 0
until	indx == nchnls do
	schedule nstrnum("alone_instr")+(indx/1000), 0, -1, indx+1
	indx	+= 1
od
