	instr puck

Sinstr		init "puck"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich			init p7

ipanfreq	random -.25, .25

ifn			init 0
imeth		init 6

iharm		init (ich%2)+1

aout		pluck $ampvar, (icps*iharm) + randomi:k(-ipanfreq, ipanfreq, 1/idur), icps, ifn, imeth

ienvvar		init idur/10

	$death

	endin
