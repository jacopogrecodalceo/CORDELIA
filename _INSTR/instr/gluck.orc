#define gluck_cps(main_freq) #$main_freq+(cent(25)*jitter:k(1, gkbeatf/8, gkbeatf))#
#define gluck_q(main_freq) #$main_freq+jitter:k(1, gkbeatf/8, gkbeatf)#

	$start_instr(gluck)


if1     init 80
if2     init 188

iq1     init 8
iq2     init 3

kq      cosseg 1, idur, 0

ain		mpulse $dyn_var, cosseg:k(0, idur, 1/idur)

aexc1	mode ain, $gluck_cps(if1), $gluck_q(iq1)
aexc2	mode ain, $gluck_cps(if2), $gluck_q(iq2)

aexc    = (aexc1+aexc2)/8
aexc    limit aexc, 0, 1

ares1   mode aexc,  $gluck_cps(icps),  $gluck_q(500)
ares2   mode aexc,  $gluck_cps(icps*22/10),  $gluck_q(420)

aout    = (ares1+ares2)/8
aout	dcblock2 aout
adel    flanger aout, a(1/$gluck_cps), kq/24

aout    = aout + adel/6

	$dur_var(10)
	$end_instr