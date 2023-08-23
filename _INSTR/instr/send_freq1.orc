maxalloc "send_freq1", 1

	instr send_freq1

Sinstr		init "send_freq1"
idur		init p3
idyn		init p4
ienv		init p5
icps		init p6/20000
ich		init p7

	prints "FREQ1 is sg %f\n", icps

acps	a icps

	outch gisend_freq1_ch, acps

	
