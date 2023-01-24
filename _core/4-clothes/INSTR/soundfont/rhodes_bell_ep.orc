	instr rhodes_bell_ep
			$params

aout	    sfplay3m 1, ftom:i(A4), $ampvar/4096, icps, 118, 1
ienvvar		init idur/10

			$death

	endin
