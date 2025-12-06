; 36*11*25
; name comes from bob and night
; inspired by bob exemple of csound
; i think by Gleb Rogozinsky
; added a kind of pan thinking for the first time in cordelia

	instr bobnite_jitter
gkbobnite_jit		jspline  .75, .75, 1/.75
	endin
	alwayson("bobnite_jitter")

	$start_instr(bobnite)

avco1		vco2 1, icps

icps_sub	init icps*6/20
while icps_sub < 15 do
	icps_sub *= 2
od

avco2		vco2 1, icps*6/20

if (ich % 2) == 1 then
	avco1	*= .35
else
	avco2	*= .75
endif

avco		sum avco1, avco2/3


afreq		cosseg   70,       idur/3,  700,   idur/3,     700,     idur/3,  70
aq			expseg   sqrt(7),  idur/2,  7.7,   idur/2,     sqrt(7)

aout		bob avco*idyn, limit(random:i(0, icps/12)+(afreq*(.5+idyn)) - gkbobnite_jit * 70, 20, 15$k), aq/2 + gkbobnite_jit, 3

	$dur_var(10)
	$end_instr