#define ipercluster_var #tab:k(linseg(giexpzero, idur, gipercluster_factor-random(1, i(gkipercluster_linvar))), gipercluster_out)#

gipercluster_factor		init 	11

gipercluster_out		ftgen	0, 0, gipercluster_factor,  -2, 0

gipercluster_pos		ftgen	0, 0, gipercluster_factor*2, -41, 2, .25, 3, .15, 11, .5, 5, .45     
gipercluster_snap		ftgen	0, 0, gipercluster_factor*4, -41, 5, .25, 3, .15, 11, .5, 15, .45      

gipercluster_linvar		init gipercluster_factor-1

	instr ipercluster
$params(ipercluster_instr)
schedule Sinstr, 0, idur, idyn, ienv, icps, ich
schedule Sinstr, 0, idur, idyn, ienv, limit(icps/8, 20, 20$k), ich
turnoff
	endin

	instr ipercluster_control
gkipercluster_linvar	= gipercluster_factor/2 + lfo((gipercluster_factor-1)/2, gkbeatf/16)
gkipercluster_vibfreq	randomh 2, 9, .5, 3
if active:k("ipercluster_instr") == 0 then
	if timeinstk() > 1 then
		printsk "I KILLED %s AND NOW IS DEAD\n", nstrstr(p1)
		turnoff
	endif
endif
	endin

	instr ipercluster_instr
	$params(ipercluster)

Sinstr_control sprintf "%s_control", Sinstr 
if active:i(Sinstr_control) == 0 then
	schedule Sinstr_control, 0, -1
endif

ift			init gisaw

kx			cosseg 1, idur/random(1, 1.25), random(0, .05)

;              		kx,   inumParms,  inumPointsX,  iOutTab,  iPosTab,  iSnapTab  [, iConfigTab] 
	        hvs1    kx, 3, gipercluster_factor, gipercluster_out, gipercluster_pos, gipercluster_snap

ain			oscil 1/2, $ipercluster_var*icps, ift

krvt		cosseg 5/icps, idur, .05/icps
ilpt		init giexpzero*10 

aout		vcomb ain, krvt+(krvt/5), ilpt, 15

aout		*= vibr(.45, (gkipercluster_vibfreq+random(-.15, .15))/idur, gisine)
aout		*= idyn

	$dur_var(100)
	$end_instr

	
