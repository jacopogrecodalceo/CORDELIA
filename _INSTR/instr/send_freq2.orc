maxalloc "send_freq2", 1

	instr send_freq2

Sinstr		init "send_freq2"
idur		init p3
idyn		init p4
ienv		init p5
icps		init p6/20000
ich		init p7

	prints "FREQ2 is sg %f\n", icps

acps	a icps

	outch gisend_freq2_ch, acps

	
