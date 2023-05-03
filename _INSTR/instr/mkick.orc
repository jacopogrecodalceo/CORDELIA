	instr mkick

	$params

ashape	envgen idur, iftenv

afreq	= ashape+(ashape*icps)+icps/10

aout	oscil3 ashape, afreq, gisine
aout	= tanh(aout)

ienvvar		init idur/100

	$END_INSTR


	endin

