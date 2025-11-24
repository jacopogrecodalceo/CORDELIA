/*
hello, i'm in duerne and i'd love to have some traitements
that can give you a radio sensation, not clearly straightforward, but
in a way that a bandpass filter act sweetly
*/

;START CORE

PARAM_1 init 1

PARAM_OUT cordelia_radio PARAM_IN, PARAM_1
;END CORE

;START INPUT
k
;END INPUT

;START OPCODE

#define cordelia_radio_low_freq_jit#jitter(500, 1/32, 1/8)#
#define cordelia_radio_high_freq_jit#jitter(1500, 1/32, 1/8)#

opcode cordelia_radio, a, ak
	ain, kwet xin

		kwet limit kwet, 0, 1

		imax_dur init i(gkbeats)
		imax_dur init imax_dur*8

		while imax_dur < .5 do
			imax_dur *= 2
		od

		arev	init 0
		aenv_delay	init 0

		aenv_pre	follow ain, (ksmps/sr)*8
		aenv_delay	vdelay3 aenv_pre+aenv_delay*(.75+jitter(.25, 1/32, 1/3)), 1/$M_PI, imax_dur
					
		aenv 	sum aenv_pre, aenv_delay

		adust	dust2 1, gkbeatf*256*k(aenv)

		; SVFILTER FREQUENCIEs BOUNDARIEs
		klow_freq		= 6500 + $cordelia_radio_low_freq_jit
		khigh_freq		= 11500 + $cordelia_radio_high_freq_jit

		a_, a_, aband svfilter adust, randomh:k(klow_freq, khigh_freq, gkbeatf+gkbeatf*k(aenv_delay)), 5

		;asum	= ain * aband/2
		aconv	cross2 ain, aband, 1024, 2, gihanning, 1
		aconv	*= 3

		; 2nd OUTPUT
		; SVFILTER FREQUENCIEs BOUNDARIEs

		; subtle wow/flutter LFO
		idepth1		init 3.5					
		irate1 		init 1/10
		amod1 		oscili idepth1+jitter(1, 1/8, 1/32), irate1, giasine

		idepth2		init 1.5
		irate2 		init 1/7
		amod2 		oscili idepth2+jitter(.5, 1/8, 1/32), irate2, giasine

		amod 		= amod1 + amod2

		awow		init 0
		awow		vdelay aconv+awow*.15, 15 + amod*10, 1000

		awow2		init 0
		awow2		vdelay ain+awow2*.15, 5 + amod*10, 1000


		klow_freq2		= 6500 + $cordelia_radio_low_freq_jit
		khigh_freq2		= 9500 + $cordelia_radio_high_freq_jit

		a_, a_, aband2 svfilter awow2+awow, randomh:k(klow_freq2, khigh_freq2, gkbeatf+gkbeatf*k(aenv_delay)), 5+jitter(2, 1/8, 1/32)

		aout =  ain*(1-kwet) + aband2*kwet;*(1-kfb/4)

	xout aout
endop

;END OPCODE
