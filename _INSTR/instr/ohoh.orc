giohohft	ftgen 0, 0, 2, -2, gisquare, gisine
giohohmorf	ftgen 0, 0, gioscildur, 10, 1

	instr ohoh

Sinstr		init "ohoh"
idur		init p3
idyn		init p4
ienv		init p5
icps		init p6
ich			init p7

ift			init 8
ifreqv		init icps/175

ai		vco2 $dyn_var, icps+random(-ifreqv, ifreqv), ift

		ftmorf phasor:k(random(.95, 1)/idur), giohohft, giohohmorf

ivib		random 9.5*idyn, 13.5*idyn
ivar		init .05

ai			*= .5+(oscil:a(.5, ivib+random(-ivar, ivar), giohohmorf))

aout		moogladder ai, icps*(75*$dyn_var), .65+random(-.15, .15)

aout		balance aout, ai

;		ENVELOPE
$dur_var(10)

		$end_instr

	
