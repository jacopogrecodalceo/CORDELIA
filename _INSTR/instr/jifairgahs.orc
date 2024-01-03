gijifairgahs_cps_last		init 0
gkjifairgahs_ph			init .25

	$start_instr(jifairgahs)

	schedule "jifairgahs_instr", 0, idur

if icps != gijifairgahs_cps_last then
	if active:i("jifairgahs_instr") > 0 then
		indx init 0
		until indx == nchnls do
			schedule "jifairgahs_rhythm", 0, idur, idyn, ienv, abs(icps-gijifairgahs_cps_last), indx+1
			indx += 1
		od
	endif
	gijifairgahs_cps_last init icps
endif
	turnoff
	endin

	instr jifairgahs_rhythm
	$params(jifairgahs_rhythm_instr)

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
	if metro:k(icps, i(gkjifairgahs_ph)) == 1 then
		schedulek Sinstr, 0, limit(idur_rhythm, .095, .75), ienv_arr[kndx], ich
		kndx += 1
	endif
endif

	endin

	instr jifairgahs_rhythm_instr
Sinstr	init "jifairgahs"
idur	init p3
idyn	init p4
ich		init p5

kcutfreq	expon random:i(13$k, 9.5$k), idur, 2500
aamp		expseg idyn, idur/3, idyn/16, idur*2/3, .00125
arand		rand aamp
alp1		butterlp arand,kcutfreq
alp2		butterlp alp1,kcutfreq
ahp1		butterhp alp2, random:i(5.5$k, 4.5$k)
asigpre		butterhp ahp1, random:i(5.5$k, 4.5$k)
aout		linen (asigpre+arand/2), 0, idur, .05

	$channel_mix
	endin

	instr jifairgahs_instr
klive	random 0, 1
	endin