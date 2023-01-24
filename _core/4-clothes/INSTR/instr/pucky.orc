	instr pucky

	$params

aout		wgpluck2 1-$ampvar, $ampvar*12, icps, 1, expseg(.65, idur, .05)

ienvvar		init idur/10

	$death

	endin
