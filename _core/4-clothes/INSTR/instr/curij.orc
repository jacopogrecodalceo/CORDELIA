	instr curij

Sinstr		init "curij"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7

if ich == 0 then
	ich random 1, ginchnls+1
elseif ich > ginchnls then
	ich random 1, ginchnls+1
endif

S1		init p8
itab		init p9
S2		init p10
idiv		init p11

aosc1		oscil3 $ampvar, fc(S1, itab, S2, idiv), gitri
aosc2		oscil3 $ampvar, fc(S1, itab, S2, idiv)*3/2, gisine

aosc		= aosc1+aosc2
ienvvar		init idur/10

aout		moogladder2 aosc/4, fc(S1, itab, S2, idiv)*(2*envgen(idur-random:i(0, ienvvar), iftenv)), .35

	$death

	endin
