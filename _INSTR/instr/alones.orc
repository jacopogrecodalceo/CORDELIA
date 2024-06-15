maxalloc "alones_instr", nchnls
maxalloc "alones", nchnls*4

gkalones_env init 0
gkalones_cps ntof "B3"

	instr alones

p3			init p3/2

Sinstr		init "alones_instr"
idur		init p3
idyn		init p4
ienv		init p5
icps		init p6
ich         init p7

	$dur_var(10)

krel		release

if ich == 1 then

	kactive			active nstrstr(p1)

	if kactive = 1 then
		gkalones_env = envgen(idur, ienv)
	elseif kactive > 1 then
		gkalones_env
	endif
	
	gkalones_cps init icps

endif

	

	instr alones_instr

Sinstr		init "alones"
ich			init p4

avco		oscil3 gkalones_env, portk:k(gkalones_cps, gkbeats/24)

aout		= avco;skf avco, gkalones_cps+(gkalones_cps*portk:k(gkalones_env*48, 95$ms)), 1.75;+$dyn_var

	$CHNMIX

	

indx	init 0
until	indx == nchnls do
	schedule nstrnum("alones_instr")+(indx/1000), 0, -1, indx+1
	indx	+= 1
od
