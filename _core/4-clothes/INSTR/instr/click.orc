	instr click

	$params

ain		fractalnoise $ampvar, expseg(.95, idur, .05)

ilpt		init 1/icps
krvt		cosseg idur, idur, idur/random:i(2, 12)
aout		comb ain, krvt, ilpt

aout		balance2 aout, ain

;		ENVELOPE
ienvvar		init idur/10

	$death

	endin
