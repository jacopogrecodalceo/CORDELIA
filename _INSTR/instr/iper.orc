
giper_factor		init 	11

giper_out		ftgen	0, 0, giper_factor,  -2, 0

giper_pos		ftgen	0, 0, giper_factor*2, -41, 2, .25, 3, .15, 11, .5, 5, .45     
giper_snap		ftgen	0, 0, giper_factor*4, -41, 5, .25, 3, .15, 11, .5, 15, .45      

gkiper_linvar		init 0
gkiper_vibfreq		init 1
giper_linvar		init giper_factor-1

#define iper_var #tab:k(linseg(0, idur, giper_factor-random(1, i(gkiper_linvar))), giper_out)#

	instr iper
$params(iper_instr)
schedule Sinstr, 0, idur, idyn, ienv, icps, ich
schedule Sinstr, 0, idur, idyn, ienv, limit(icps/8, 20, 20$k), ich
turnoff
	endin

	instr iper_control
gkiper_linvar	= giper_factor/2 + lfo((giper_factor-1)/2, gkbeatf/32)
gkiper_vibfreq	jitter 3, gkbeatf/9, gkbeatf/24
if active:k("iper_instr") == 0 then
	if timeinstk() > 1 then
		printsk "I KILLED %s AND NOW IS DEAD\n", nstrstr(p1)
		turnoff
	endif
endif
	endin

	instr iper_instr
	$params(iper)

Sinstr_control sprintf "%s_control", Sinstr 
if active:i(Sinstr_control) == 0 then
	schedule Sinstr_control, 0, -1
endif

ift			init gisaw

kx			cosseg 1, idur/random(1, 1.25), random(0, .05)

;              		kx,   inumParms,  inumPointsX,  iOutTab,  iPosTab,  iSnapTab  [, iConfigTab] 
	        hvs1    kx, 3, giper_factor, giper_out, giper_pos, giper_snap

ain			oscil 1/2, $iper_var*icps, ift
aout		= ain*vibr(.5, (gkiper_vibfreq+random(-.05, .05))/idur, gisine)
aout		*= idyn

	$dur_var(100)
	$end_instr

	
