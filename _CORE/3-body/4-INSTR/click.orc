	instr click

Sinstr		init "click"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6

ain		fractalnoise iamp*2, expseg(.95, idur, .05)

;a1		*= envgen(idur-random:i(0, ienvvar), iftenv)

#define click_krvt	#cosseg(idur, idur, idur/random:i(2, 12))#

ilpt		init 1/icps

a1		comb ain, $click_krvt, ilpt
a2		comb ain, $click_krvt, ilpt

a1		balance a1, ain*$ampvar
a2		balance a2, ain*$ampvar

;		ENVELOPE
ienvvar		init idur/10

$env1
$env2

;		ROUTING
S1		sprintf	"%s-1", Sinstr
S2		sprintf	"%s-2", Sinstr

		chnmix a1, S1
		chnmix a2, S2

	endin
