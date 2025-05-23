giance_1		ftgen 0, 0, 8192, 9, \
    20,1.00, 25,0.93, 31.5,0.85, 40,0.78, 50,0.71, 63,0.65, \
    80,0.60, 100,0.55, 125,0.52, 160,0.48, 200,0.45, \
    250,0.42, 315,0.40, 400,0.38, 500,0.37, 630,0.36, \
    800,0.36, 1000,0.37, 1250,0.38, 1600,0.39, 2000,0.40, \
    2500,0.42, 3150,0.44, 4000,0.46, 5000,0.48, 6300,0.51, \
    8000,0.53, 10000,0.56, 12500,0.59, 16000,0.63, 20000,0.66

giance_2		ftgen 0, 0, 8192, 10, \
    20,1.00, 25,0.93, 31.5,0.85, 40,0.78, 50,0.71, 63,0.65, \
    80,0.60, 100,0.55, 125,0.52, 160,0.48, 200,0.45, \
    250,0.42, 315,0.40, 400,0.38, 500,0.37, 630,0.36, \
    800,0.36, 1000,0.37, 1250,0.38, 1600,0.39, 2000,0.40, \
    2500,0.42, 3150,0.44, 4000,0.46, 5000,0.48, 6300,0.51, \
    8000,0.53, 10000,0.56, 12500,0.59, 16000,0.63, 20000,0.66

gkance_cps_vib init 1.5
giance_index init 0
giance_factor init 8
#define ance_ladder_q			# .5+jitter(.35, 1/9, 1/3) #
#define ance_cps_vib			# lfo:a(icps_var, kvib_freq+jitter(kvib_freq/9, 1/9, 1/3)*linseg(0, idur, 1))*cosseg(0, idur, 1) #

    $start_instr(ance)

if random:i(0, 1) > .95 then

	idur_ghost limit idur * random(3, 9), idur, 12

	icps_ghost init icps * pow(2, int(random(-2, 3)))
	while icps_ghost > 20000 do
		icps_ghost /= 2
	od
	while icps_ghost < 20 do
		icps_ghost *= 2
	od

	schedule "ance", 0, idur_ghost, idyn*random(.25, 1), gitri, icps_ghost, ich
	prints "***ANCE GHOST ACTIVATED\n"
endif

icps_var	init icps*11/10-icps
ift1		init giance_1
ift2		init giance_2

kvib_freq	init i(gkance_cps_vib)
kvib_freq	+= jitter(gkance_cps_vib/9, gkbeatf/32, gkbeatf/9)

isin		sin floor(giance_index)
isin		= giance_factor+1+isin*giance_factor

a1		oscil3 $dyn_var, icps + $ance_cps_vib, ift1
a1		moogladder2 a1, limit(icps*isin+jitter(icps_var, gkbeatf/9, gkbeatf), 20, 20$k), $ance_ladder_q

a2		oscil3 $dyn_var, icps + $ance_cps_vib, ift1
a2		moogladder2 a2, limit(icps*isin+jitter(icps_var, gkbeatf/12, gkbeatf), 20, 20$k), $ance_ladder_q

a3		oscil3 $dyn_var, icps + $ance_cps_vib, ift2
a3		moogladder2 a3, limit(icps*isin+jitter(icps_var, gkbeatf/32, gkbeatf), 20, 20$k), $ance_ladder_q

a4		oscil3 $dyn_var, icps*4 + $ance_cps_vib, ift2
a4		moogladder2 a4, limit(icps*isin+jitter(icps_var, gkbeatf/32, gkbeatf), 20, 20$k), $ance_ladder_q

aout		= a1 + a2 + a3 + a4/2 
aout		*= 2
	giance_index += 1/nchnls
	$dur_var(5)
	$end_instr

