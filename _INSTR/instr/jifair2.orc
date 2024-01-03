gijifair2_cps_last init 0

	$start_instr(jifair2)

	schedule "jifair2_instr", 0, idur, idyn, ienv, icps, ich

if icps != gijifair2_cps_last then
	if active:i("jifair2_instr") > 0 then
		indx init 0
		until indx == nchnls do
			schedule "jifair2_mark", 0, idur, idyn, ienv, abs(icps-gijifair2_cps_last), indx+1
			indx += 1
		od
	endif
	gijifair2_cps_last init icps
endif
	turnoff
	endin

	instr jifair2_mark
	$params(jifair2)
;schedule Sinstr, 0, .5, idyn, ich
	print icps
if icps < 30 then
	ktrig metro icps
	kenv_trig triglinseg ktrig, 0, .005, 1, idur-.005, 0
endif

aosc	oscili .85, cosseg(random:i(90, 120), idur, random:i(25, 45))
anoi	fractalnoise .85, .5
aosc	balance2 aosc, anoi
aout	= (aosc + (anoi/64))*4
aout	= aout*a(kenv_trig)*linseg:a(0, .05, 1, idur-(.05*2), 1, .05, 0)*idyn

	$channel_mix
	endin

	instr jifair2_instr
	$params(jifair2)
aout	oscili idyn/6, icps
	$dur_var(10)
	$end_instr
