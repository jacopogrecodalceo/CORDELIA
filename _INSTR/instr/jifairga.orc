gijifairga_cps_last		init 0
gkjifairga_ph			init .25

	$start_instr(jifairga)

	schedule "jifairga_instr", 0, idur

if icps != gijifairga_cps_last then
	if active:i("jifairga_instr") > 0 then
		indx init 0
		until indx == nchnls do
			schedule "jifairga_rhythm", 0, idur, idyn, ienv, abs(icps-gijifairga_cps_last), indx+1
			indx += 1
		od
	endif
	gijifairga_cps_last init icps
endif
	turnoff
	endin

	instr jifairga_rhythm
	$params(jifairga_rhythm_instr)

if icps > 1 && icps < 20 then
	; Array with point for the gen
	isegment	init 1/icps
	ipoints		ceil idur / isegment
	ienv_arr[]	init ipoints
	indx		init 0

	until indx == ipoints do
		ienv_arr[indx]	tablei ((isegment)*indx)/idur, ienv, 1
		indx += 1
	od
		scalearray ienv_arr, 0, 1

	idur_rhythm init (1/icps)*2
	kndx init 0
	if metro:k(icps, i(gkjifairga_ph)) == 1 then
		schedulek Sinstr, 0, limit(idur_rhythm, .095, .75), ienv_arr[kndx], ich
		kndx += 1
	endif
endif

	endin

	instr jifairga_rhythm_instr
Sinstr	init "jifairga"
idur	init p3
idyn	init p4/4
ich		init p5

aosc	oscili 1, linseg(random:i(90, 120), idur, random:i(25, 45))
aout	= aosc * linseg:a(0, .005, 1, idur-.005, 0) * idyn

	$channel_mix
	endin

	instr jifairga_instr
klive	random 0, 1
	endin