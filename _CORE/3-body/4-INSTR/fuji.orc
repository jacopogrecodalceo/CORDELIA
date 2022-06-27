	instr fuji_control

gkfuji_form	randomi $ppp, $fff, gkbeatf/4, 3
gkfuji_oct	randomi $pppp, $mf, gkbeatf/4, 3

	endin
	alwayson("fuji_control")

	instr fuji

Sinstr		init "fuji"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7

kris 		init .0035
kdur 		init .0095
kdec 		init .0075

iolaps		init icps * idur

ifna		init gisine  ; Sine wave
ifnb		init iftenv  ; Straight line rise shape

itotdur		init idur

kphs		= 1  ; No phase modulation (constant kphs)

kfund		= icps+random:i(-icps/1000, icps/1000)
;kform		cosseg icps, idur, icps*(1+($ampvar)*idur)
kform		= icps+(table3(line:k(0, idur, 1), iftenv, 1)*gkfuji_form*idur)

koct		= gkfuji_oct*idur*(1-table3(line:k(0, idur, 1), iftenv, 1))
;koct		= idur*(table3(line:k(0, idur, 1), iftenv, 1))

kband		= (1-($ampvar))*(16+idur);line 60, idur, 25
kgliss		= $ampvar;line p16, p3, p17

aout    fof2    $ampvar, kfund, kform, \
		koct, kband, kris, kdur, \
		kdec, iolaps, ifna, \
		ifnb, itotdur, kphs, kgliss

kfreq		cosseg (icps*48)+(icps*$ampvar), idur, (icps*256)+(icps*$ampvar)
;kfreq		= (icps*(9*$ampvar))+(table3(cosseg:k(0, idur, 1), iftenv, 1)*((64*$ampvar*3.5)*icps))

;kfreq		= (icps*16)+((koct*icps)*16)

kfreq		limit kfreq, 7.5$k, 19.5$k

aout		moogladder2 aout, kfreq, $ampvar


ienvvar		init idur/25

	$death

	endin
