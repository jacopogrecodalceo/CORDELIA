	instr mkick

	$params

ashape	envgen idur, ienv

afreq	= ashape+(ashape*icps)+icps/10

aout	oscil3 ashape, afreq, gisine
aout	= tanh(aout)

$dur_var(100)

	$end_instr


	

