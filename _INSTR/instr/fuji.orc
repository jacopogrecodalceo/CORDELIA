	instr fuji_control

;gkfuji_form	randomi $ppp, $fff, gkbeatf/4, 3
;gkfuji_oct	randomi $pppp, $mf, gkbeatf/4, 3
gkfuji_form	scale jitter:k(1, gkbeatf/8, gkbeatf/4), $fff, $ppp, 1, -1
gkfuji_oct	scale jitter:k(1, gkbeatf/8, gkbeatf/4), $mf, $pppp, 1, -1

	
	alwayson("fuji_control")

	$start_instr(fuji)

kris 		init .0035
kdur 		init .0095
kdec 		init .0075

iolaps		init icps * idur

ifna		init gisine  ; Sine wave
ifnb		init ienv  ; Straight line rise shape

itotdur		init idur

kphs		= 1  ; No phase modulation (constant kphs)

kfund		= icps+random:i(-icps/1000, icps/1000)
;kform		cosseg icps, idur, icps*(1+($dyn_var)*idur)
kform		= icps+(table3(line:k(0, idur, 1), ienv, 1)*gkfuji_form*idur)

koct		= gkfuji_oct*idur*(1-table3(line:k(0, idur, 1), ienv, 1))
;koct		= idur*(table3(line:k(0, idur, 1), ienv, 1))

kband		= (1-($dyn_var))*(16+idur);line 60, idur, 25
kgliss		= $dyn_var;line p16, p3, p17

aout    fof2    $dyn_var, kfund, kform, \
		koct, kband, kris, kdur, \
		kdec, iolaps, ifna, \
		ifnb, itotdur, kphs, kgliss

kfreq		cosseg (icps*48)+(icps*$dyn_var), idur, (icps*256)+(icps*$dyn_var)
;kfreq		= (icps*(9*$dyn_var))+(table3(cosseg:k(0, idur, 1), ienv, 1)*((64*$dyn_var*3.5)*icps))

;kfreq		= (icps*16)+((koct*icps)*16)

kfreq		limit kfreq, 7.5$k, 19.5$k

aout		moogladder2 aout, kfreq, $dyn_var

	$dur_var(25)
	$end_instr

