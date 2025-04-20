gijifair_cps_last[] init nchnls

	$start_instr(jifair)

	schedule "jifair_instr", 0, idur, idyn, ienv, icps, ich

icps_last init gijifair_cps_last[ich-1]

if icps != icps_last then
	icps_diff	abs icps - icps_last
	if active:i("jifair_instr") > 0 then
		schedule "jifair_mark", 0, idur, idyn, ienv, icps_diff, ich
	endif
	gijifair_cps_last[ich-1] init icps
endif
	turnoff
	endin

	instr jifair_mark
	$params(jifair_mark_instr)
;schedule Sinstr, 0, .5, idyn, ich
print icps
if icps < 20 then
	idur init 1/icps
	if metro:k(icps) == 1 then
		schedulek Sinstr, 0, limit(idur, .095, .75), idyn, ich
	endif
else
	turnoff
endif
	endin

	instr jifair_mark_instr
Sinstr init "jifair"
idur init p3
idyn init p4
ich init p5
aosc    oscili idyn, linseg(random:i(90, 120), idur, random:i(25, 45))

anoi_in	fractalnoise .65, .5
anoi_lo	moogladder2 anoi_in, linseg(random:i(90, 120)*6, idur, random:i(25, 45))*4, .75
anoi_hi	skf anoi_in, 2*random:i(3500, 4000)+jitter:k(100, gkbeatf/8, gkbeatf), 1+(.45*3), 1

anoi	= anoi_lo*2 + anoi_hi/96

aout	= (aosc + (anoi/48))
aout    = aout * linseg:a(0, .005, 1, idur-.005, 0)
	$channel_mix
	endin

	instr jifair_instr
	$params(jifair)
aout    oscili idyn/2, icps
	$dur_var(10)
	$end_instr
