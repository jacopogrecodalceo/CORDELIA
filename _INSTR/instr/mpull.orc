#define mpull_cps #icps+jitter:k(1/12, gkbeatf/12, gkbeatf)#

	opcode	mpulse_filter, a, aiio
ain, ifreq, iq, indx	xin

iharm		init 18
amain_out	init 0
if		indx==iharm goto next
aout mpulse_filter ain, ifreq, iq, indx+1

next:
aout		areson ain, ifreq*indx, iq

	xout aout

	endop

	$start_instr(mpull)

ain		mpulse $dyn_var, 1/$mpull_cps
a0			init 0

ifreq		init icps;ntof "4F#"
iq			init 250
aout		areson ain, ifreq/4, iq
aout		areson ain, ifreq/2, iq
aout		areson aout, ntof("4F#"), iq
aout		areson aout, ntof("4F#"), iq/2
aout		areson aout, ntof("4F#"), iq/4
aout		areson aout, ntof("5F#"), iq
aout		areson aout, ntof("5F#"), iq
aout		areson aout, ntof("4F#"), iq
aout		areson aout, ifreq, iq
aout		areson aout, ifreq, iq
aout		areson aout, ifreq, iq
aout		areson aout, ifreq*2, iq
aout		areson aout, ifreq*4, iq
aout		areson aout, ifreq*8, iq

aout		dcblock2 aout
aout		balance2 aout, ain	

	$dur_var(10)
	$end_instr