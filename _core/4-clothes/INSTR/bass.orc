	instr bass

Sinstr		init "bass"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7

a1_out		oscil3 $ampvar, icps, gisine
a2_out		foscil $ampvar, icps, cosseg(1, idur/24, 2), cosseg(2, idur, .5), line(.25, idur, 1), gisine
a3_out		foscil $ampvar, icps*3/2, cosseg(.25, idur/32, 2), .25, line(1, idur, 0), gisine

aout		= a1_out + a2_out/4 + a3_out/8
ienvvar		init idur/50

	$death

	endin
