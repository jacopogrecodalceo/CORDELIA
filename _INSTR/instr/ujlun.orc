
	instr ujlun

		$params(ujlun_instr)
inum	init nstrnum(Sinstr)+ich/100
		schedule inum, 0, -(idur+.05), idyn, ienv, icps, ich
		turnoff

	endin

gkujlun_filter init 1
	instr ujlun_control

	gkujlun_filter = 12 + lfo(8, randomi:k(1/32, 1/12, .125))

	endin
	alwayson("ujlun_control")

	instr ujlun_instr

	$params(ujlun)

itie	tival
iport	init idur/6
until iport < idur do
	iport /= 2
od

iatk	init .005

iphase init -1
ktime init 0

tigoto SKIP_INIT
	; if it is tied note skip this
	iphase init 0
	icps_last init icps
	idyn_last init idyn

SKIP_INIT:
if (itie == 0 && p3 < 0) then
	;prints "TIED: INITIAL NOTE\n"
	aenv	cosseg 0, iatk, idyn
	kcps	init icps
	kvib	cosseg 0, idur, 1

elseif (p3 < 0 && itie == 1) then
	;prints "TIED: MIDDLE NOTE\n"
	aenv	cosseg idyn_last, iport, idyn
	kcps	cosseg icps_last, iport, icps
	kvib	= oscili(1, portk(cosseg:k(0, idur/2, 1)*kcps/250, iport*2, icps_last/250), gisine, iphase)
	icps_last init icps
	idyn_last init idyn
endif

ktime timeinsts
if ktime > idur then
	turnoff2 p1, 4, 1
endif

irel_time init idur/6

	xtratim irel_time
krel release
if krel == 1 then
	icps_rel init icps_last/2
	while icps_rel > 20 do
		icps_rel /= 2
	od

	aenv	cosseg idyn_last, irel_time, 0
	kcps	cosseg icps_last, irel_time, icps_rel
	kvib	cosseg 1, irel_time, 0
endif

/* 	aosc	oscili .75+kvib*.25, jitter:k(kcps/100, 1/6, 1/3)+kcps*2+kvib*kcps/500, gitri, iphase

avco	vco2 .85+kvib*.15, kcps+kvib*kcps/500, itie
avco	zdf_ladder avco, limit(kcps*2+jitter:k(1, 1/idur, .5/idur)*kcps, 20, 20$k), 7.25+jitter:k(5, 1/idur, .5/idur), itie
*/


tigoto SKIP_K
	kjitter_cps_zdf = jitter:k(3, gkbeatf, gkbeatf/8)*kcps
	kjitter_q_zdf	jitter 5, gkbeatf, gkbeatf/8

	kjitter_cps_k35 = jitter:k(3, gkbeatf, gkbeatf/8)*kcps
	kjitter_q_k35	jitter 4, gkbeatf, gkbeatf/8
	
SKIP_K:

avco	vco2 $dyn_var, kcps+kvib*kcps/500, itie

azdf	zdf_ladder	avco, limit(kcps*2*gkujlun_filter+kjitter_cps_zdf, 20, 20000), 7.25+kjitter_q_zdf, 			itie
ak35	K35_lpf		avco, limit(kcps*3*gkujlun_filter+kjitter_cps_k35, 20, 20000), 5.25+kjitter_q_k35, 1, 1.15,	itie

aout	= (azdf + ak35) / 2

aout *= aenv

$dur_var(10)
$channel_mix

	endin