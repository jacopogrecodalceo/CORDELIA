giperfactor		init 	11

giperout		ftgen	0, 0, giperfactor,  -2, 0

giperpos		ftgen	0, 0, giperfactor*2, -41, 2, .25, 3, .15, 11, .5, 5, .45     
gipersnap		ftgen	0, 0, giperfactor*4, -41, 5, .25, 3, .15, 11, .5, 15, .45      

gipercluster_linvar	init giperfactor-1

	instr ipercluster

Sinstr		init "ipercluster_instr"
idur		init p3
idyn		init p4
ienv		init p5
icps		init p6
ich			init p7

	schedule Sinstr, 0, idur, idyn, ienv, icps, ich
	schedule Sinstr, 0, idur, idyn, ienv, limit(icps/8, 20, 20$k), ich
	turnoff

	

	instr ipercluster_control

gkipercluster_linvar	= giperfactor/2 + lfo((giperfactor-1)/2, gkbeatf/16)
gkipercluster_vibfreq	randomh 2, 9, .5, 3

	
	alwayson("ipercluster_control")

	instr ipercluster_instr

Sinstr		init "ipercluster"
idur		init p3
idyn		init p4
ienv		init p5
icps		init p6
ich			init p7

ift		init gisaw

kx		expseg 1, idur/random(1, 1.25), random(giexpzero, giexpzero*100)

;              		kx,   inumParms,  inumPointsX,  iOutTab,  iPosTab,  iSnapTab  [, iConfigTab] 
	        hvs1    kx, 3, giperfactor, giperout, giperpos, gipersnap

#define ipercluster_var #tab:k(linseg(giexpzero, idur, giperfactor-random(1, i(gkipercluster_linvar))), giperout)#

ain		oscil $dyn_var, $ipercluster_var*icps, ift

krvt		cosseg 5/icps, idur, .05/icps
ilpt		init giexpzero*10 

aout		vcomb ain, krvt+(krvt/5), ilpt, 15

aout		*= vibr(.45, (gkipercluster_vibfreq+random(-.15, .15))/idur, gisine)

;		ENVELOPE
$dur_var(100)

			$end_instr

	
