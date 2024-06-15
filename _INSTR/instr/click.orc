	$start_instr(click)

ain		fractalnoise $dyn_var, expseg(.95, idur, .05)

ilpt		init 1/icps
krvt		cosseg idur, idur, idur/random:i(2, 12)
aout		comb ain, krvt, ilpt

aout		balance2 aout, ain

aout		/= 3

;		ENVELOPE
$dur_var(10)

	$end_instr

