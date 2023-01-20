	instr rhodes_bell_slow_trmk
			$params

aout	    sfplay3m 1, ftom:i(A4), $ampvar/4096, icps, 120, 1
ienvvar		init idur/10

			$death

	endin
