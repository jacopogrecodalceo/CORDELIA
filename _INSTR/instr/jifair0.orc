gijifair0_cps_last init 0

	$start_instr(jifair0)

	schedule "jifair0_instr", 0, idur

if icps != gijifair0_cps_last then
	if active:i("jifair0_instr") > 0 then
		indx init 0
		until indx == nchnls do
			schedule "jifair0_mark", 0, idur, idyn, ienv, abs(icps-gijifair0_cps_last), indx+1, icps
			indx += 1
		od
	endif
	gijifair0_cps_last init icps
endif
	turnoff
	endin

	instr jifair0_mark
	$params(jifair0)
icps_jifair0 init p9
;schedule Sinstr, 0, .5, idyn, ich
	print icps
if icps < 30 then
	ktrig metro icps
	kenv_trig triglinseg ktrig, 0, .005, 1, .75-.005, 0
endif

until icps_jifair0 < 120 do
	icps_jifair0 /= 2
od

aosc	oscili idyn, cosseg(icps_jifair0, idur, random:i(25, 45));cosseg(random:i(90, 120), idur, random:i(25, 45))
anoi	fractalnoise .65, .5
aout	= (aosc + (anoi/128))*4
aout	*= a(kenv_trig)

	$dur_var(10)
	$end_instr

	instr jifair0_instr
	prints "jifair0_instr no sound\n"
	endin
