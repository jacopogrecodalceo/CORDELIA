gijifair3_cps_last init 0

	$start_instr(jifair3)

	schedule "jifair3_instr", 0, idur, idyn, ienv, icps, ich

if icps != gijifair3_cps_last then
	if active:i("jifair3_instr") > 0 then
		indx init 0
		until indx == nchnls do
			schedule "jifair3_mark", 0, idur, idyn, ienv, abs(icps-gijifair3_cps_last), indx+1, icps
			indx += 1
		od
	endif
	gijifair3_cps_last init icps
endif
	turnoff
	endin

	instr jifair3_mark
	$params(jifair3)
icps_jifair3 init p9
;schedule Sinstr, 0, .5, idyn, ich
	print icps
if icps < 30 then
	ktrig metro icps
	kenv_trig triglinseg ktrig, 0, .005, 1, .75-.005, 0
endif

until icps_jifair3 < 120 do
	icps_jifair3 /= 2
od

aosc	oscili idyn, cosseg(icps_jifair3, idur, random:i(25, 45));cosseg(random:i(90, 120), idur, random:i(25, 45))
anoi	fractalnoise .65, .5
aout	= (aosc + (anoi/128))*6
aout	*= a(kenv_trig)

	$dur_var(10)
	$end_instr

	instr jifair3_instr
	$params(jifair3)
aout	oscili idyn/3, icps
	$dur_var(10)
	$end_instr
