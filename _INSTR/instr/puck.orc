	$start_instr(puck)

ipanfreq	random -.25, .25

ifn			init 0
imeth		init 6

iharm		init (ich%2)+1

aout		pluck $dyn_var, (icps*iharm) + randomi:k(-ipanfreq, ipanfreq, 1/idur), icps, ifn, imeth

	$dur_var(10)
	$end_instr