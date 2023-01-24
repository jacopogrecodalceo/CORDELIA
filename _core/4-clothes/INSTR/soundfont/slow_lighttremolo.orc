	instr slow_lighttremolo
			$params

aout	    sfplay3m 1, ftom:i(A4), $ampvar/4096, icps, 111, 1
ienvvar		init idur/10

			$death

	endin
