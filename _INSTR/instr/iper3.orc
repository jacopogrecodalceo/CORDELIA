
giper3_factor		init 	11

giper3_out		ftgen	0, 0, giper3_factor,  -2, 0

giper3_pos		ftgen	0, 0, giper3_factor*2, -41, 2, .25, 3, .15, 11, .5, 5, .45     
giper3_snap		ftgen	0, 0, giper3_factor*4, -41, 5, .25, 3, .15, 11, .5, 15, .45      

gkiper3_linvar		init 0
gkiper3_vibfreq		init 1
giper3_linvar		init giper3_factor-1

#define iper3_var #tab:k(linseg(0, idur, giper3_factor-random(1, i(gkiper3_linvar))), giper3_out)#

	instr iper3
$params(iper3_instr)
schedule Sinstr, 0, idur, idyn, ienv, icps, ich
schedule Sinstr, 0, idur, idyn, ienv, limit(icps/8, 20, 20$k), ich
turnoff
	endin

	instr iper3_control
gkiper3_linvar	= giper3_factor/2 + lfo((giper3_factor-1)/2, gkbeatf/32)
gkiper3_vibfreq	jitter 3, gkbeatf/9, gkbeatf/24
if active:k("iper3_instr") == 0 then
	if timeinstk() > 1 then
		printsk "I KILLED %s AND NOW IS DEAD\n", nstrstr(p1)
		turnoff
	endif
endif
	endin

	instr iper3_instr
	$params(iper3)

Sinstr_control sprintf "%s_control", Sinstr 
if active:i(Sinstr_control) == 0 then
	schedule Sinstr_control, 0, -1
endif

kx			= .5+jitter(.5, gkbeatf/4, gkbeatf/12)
ky			= .5+jitter(.5, gkbeatf/4, gkbeatf/12)
kz			= .5+jitter(.5, gkbeatf/4, gkbeatf/12)

;              		kx,   inumParms,  inumPointsX,  iOutTab,  iPosTab,  iSnapTab  [, iConfigTab] 
	        hvs3    kx, ky, kz, 3, giper3_factor, giper3_factor*2, giper3_factor*3, giper3_out, giper3_pos, giper3_snap

ain			vco2 1/2, $iper3_var*icps
aout		= ain*vibr(.5, (gkiper3_vibfreq+random(-.05, .05))/idur, gisine)
aout		*= idyn

	$dur_var(100)
	$end_instr

	
