gijifair0_cps_last[] init nchnls

	$start_instr(jifair0)

	schedule "jifair0_instr", 0, idur

icps_last init gijifair0_cps_last[ich-1]

if icps != icps_last then
	icps_diff	abs icps - icps_last
	if active:i("jifair0_instr") > 0 && icps_diff < 35 then
					;p1				p2 p3	 p4	   p5 	 p6			p7
		schedule	"jifair0_mark", 0, idur, idyn, ienv, icps_diff, ich, icps
	endif
	gijifair0_cps_last[ich-1] init icps
endif
	turnoff
	endin

	instr jifair0_mark
	$params(jifair0)
icps_jifair0 init p8
;schedule Sinstr, 0, .5, idyn, ich
	print icps
	ktrig metro icps
	kenv_trig triglinseg ktrig, 0, .005, 1, .75-.005, 0

until icps_jifair0 < 120 do
	icps_jifair0 /= 2
od

aosc	oscil3 idyn*3, cosseg(icps_jifair0, idur, random:i(25, 45));cosseg(random:i(90, 120), idur, random:i(25, 45))
anoi	fractalnoise idyn / 8, .5
anoi 	K35_hpf anoi, limit(icps_jifair0*4+jitter(icps_jifair0/3, 1/p3, .5/p3), 20, 20$k), 9.5, 3.5, .5
	
aout	= (aosc + anoi)
aout	*= a(kenv_trig) / 4

	$dur_var(10)
	$end_instr

	instr jifair0_instr
prints "i am no sound.\n"
	endin
