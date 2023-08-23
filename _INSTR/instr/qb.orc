		instr qb_control

gkqb_freq	abs lfo(gkbeatf*2, gkbeatf/24, 1)
gkqb_q		lfo .235, gkqb_freq/2, 1

gkqb_freq	samphold gkqb_freq, metro($M_PI*(1+(gkqb_q/4)))

		
		alwayson("qb_control")

		instr qb

Sinstr		init "qb"
idur		init p3
idyn		init p4
ienv		init p5
icps		init p6
ich		init p7
$dur_var(10)

;kfreq		init icps/50;expseg icps/random:i(25, 50), p3, icps/random:i(25, 50)

;		OSCIL
ain1		oscil3 $dyn_var, icps, gitri
ain2		oscil3 $dyn_var, icps*(3/2), gitri
ain3		oscil3 $dyn_var, icps*(9/8), gitri
ain4		oscil3 $dyn_var, icps*(9/4), gitri

a1		= ain1 * oscil:a(1, gkqb_freq, gisotrap)
a2		= ain2 * oscil:a(1, gkqb_freq/3, gisotrap)
a3		= ain3 * oscil:a(1, $M_PI, gisotrap)

apre		= a1 + (a2/2) + (a3/2) + (ain4*expseg:a(1, idur/6, gizero)) 
apre		/= 4

;		FXs
aph		phaser1 apre, gkqb_freq*2, 50, .75+gkqb_q

afl		flanger apre, a(gkqb_freq)*4, .75+gkqb_q

alast		= (apre/2) + aph + (afl*2)

aout		moogladder2 alast, (20$k)*(idyn*2.75), random:i(.5, .75)
aout		balance2 aout, apre

		$end_instr

		
