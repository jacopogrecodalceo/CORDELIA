; JI rhythm with frequency division

gijifairga3h_cps_last		init 0
gkjifairga3h_ph			init .25

	$start_instr(jifairga3h)

	schedule "jifairga3h_instr", 0, idur

if icps != gijifairga3h_cps_last then
	if active:i("jifairga3h_instr") > 0 then
		indx init 0
		until indx == nchnls do
			schedule "jifairga3h_rhythm", 0, idur, idyn, ienv, abs(icps-gijifairga3h_cps_last), indx+1
			indx += 1
		od
	endif
	gijifairga3h_cps_last init icps
endif
	turnoff
	endin

	instr jifairga3h_rhythm
	$params(jifairga3h_rhythm_instr)

until icps > 1 do
	icps *= 2
od

until icps < 10 do
	icps /= 2
od

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
kdyn_var init 1
if metro:k(icps, i(gkjifairga3h_ph)) == 1 then
	if (kndx%16) == 0 then
		kdyn_var = 1
	else
		kdyn_var = 1/16
	endif
	schedulek Sinstr, 0, limit(idur_rhythm, .095, .75), ienv_arr[kndx]*kdyn_var, ich
	kndx += 1
endif

	endin

	instr jifairgah_rhythm_instr
Sinstr	init "jifairgah"
idur	init p3
idyn	init p4
ich		init p5

kcutfreq	expon 15000, idur, 2500
kamp		expon idyn, idur, .00125
arand		fractalnoise kamp, 0
alp1		butterlp arand,kcutfreq
alp2		butterlp alp1,kcutfreq
ahp1		butterhp alp2, 9500
asigpre		butterhp ahp1, 5500
aout		linen (asigpre+arand/2), 0, idur, .05

	$channel_mix
	endin

	instr jifairga3h_instr
klive	random 0, 1
	endin
