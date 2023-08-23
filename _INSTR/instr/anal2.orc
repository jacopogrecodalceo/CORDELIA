	$start_instr(anal)


imode	init 16
kpw	abs jitter(1, gkbeatf/4, gkbeatf)
kphs	abs jitter(1, gkbeatf/4, gkbeatf)
inyx	init .25

kndx	samphold jitter(1, gkbeatf/4, gkbeatf), metro:k(gkbeatf*8)
kvibf	= lfo(icps/100, random:i(2.5, 4.5))

ivibdiv		random 4, 8
kvibd		= lfo(1, cosseg(random:i(idur*.35, idur*.95)/ivibdiv, idur, random:i(idur*.75, idur*3.5)/ivibdiv))*cosseg(1, idur, 0)

ilen		tab_i 0, i(gktuning)
ioff		init 4
itun_len	init ilen - ioff

ktun_dec		tab (abs(kndx)*itun_len)+ioff, i(gktuning)

kcps	= portk(icps * ktun_dec, .025)+kvibf
aout	vco2 $dyn_var*abs(kvibd), kcps, imode, kpw, kphs, inyx

	$dur_var(10)
	$end_instr


