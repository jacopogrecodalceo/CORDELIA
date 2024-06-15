gijifair_cps_last init 0

	$start_instr(jifair)

	schedule "jifair_instr", 0, idur, idyn, ienv, icps, ich

if icps != gijifair_cps_last then
	if active:i("jifair_instr") > 0 then
		indx init 0
		until indx == nchnls do
			schedule "jifair_mark", 0, idur, idyn, ienv, abs(icps-gijifair_cps_last), indx+1
			indx += 1
		od
	endif
	gijifair_cps_last init icps
endif
	turnoff
	endin

	instr jifair_mark
	$params(jifair_mark_instr)
;schedule Sinstr, 0, .5, idyn, ich
	print icps
idur init 1/icps
if icps < 20 then
	if metro:k(icps) == 1 then
		schedulek Sinstr, 0, limit(idur, .095, .75), idyn, ich
	endif
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
aout    = aout * linseg:a(0, .005, 1, idur-.005, 0) * 2
	$channel_mix
	endin

	instr jifair_instr
	$params(jifair)
aout    oscili idyn/2, icps
	$dur_var(10)
	$end_instr
