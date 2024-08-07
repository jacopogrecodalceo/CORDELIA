gijifairgah_cps_last		init 0
gkjifairgah_ph			init .25

	$start_instr(jifairgah)

	schedule "jifairgah_instr", 0, idur

if icps != gijifairgah_cps_last then
	if active:i("jifairgah_instr") > 0 then
		indx init 0
		until indx == nchnls do
			schedule "jifairgah_rhythm", 0, idur, idyn, ienv, abs(icps-gijifairgah_cps_last), indx+1
			indx += 1
		od
	endif
	gijifairgah_cps_last init icps
endif
	turnoff
	endin

	instr jifairgah_rhythm
	$params(jifairgah_rhythm_instr)

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

	idur_rhythm init (1/icps)*4
	kndx init 0
	if metro:k(icps, i(gkjifairgah_ph)) == 1 then
		schedulek Sinstr, 0, limit(idur_rhythm, .095, .75), ienv_arr[kndx], ich
		kndx += 1
	endif
endif

	endin

	instr jifairgah_rhythm_instr
Sinstr	init "jifairgah"
idur	init p3
idyn	init p4
ich		init p5

kcutfreq	expon 10000, idur, 2500
aamp		expon idyn, idur, .00125
arand		rand aamp
alp1		butterlp arand,kcutfreq
alp2		butterlp alp1,kcutfreq
ahp1		butterhp alp2, 5500
asigpre		butterhp ahp1, 5500
aout		linen (asigpre+arand/2), 0, idur, .05

	$channel_mix
	endin

	instr jifairgah_instr
klive	random 0, 1
	endin