<CsoundSynthesizer>
<CsOptions>
;--port=10000
;--format=float
-3
-m0
-D
;-+msg_color=1
--messagelevel=96
--m-amps=1
-odac3.wav
;-odac
</CsOptions>
<CsInstruments>

;sr		=	192000
sr		=	48000
0dbfs		=	1

ksmps		=	1	;leave it at 64 for real-time
;nchnls_i	=	12
nchnls		=	2
;A4		=	438	;only for ancient music	
gSfile init "/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/sixcorrect.wav"
gilen filelen gSfile
gieuler_diat ftgen 0, 0, 0, -2, 8, 2/1, A4, 69, 1, 9/8, 5/4, 4/3, 45/32, 3/2, 5/3, 15/8, 2/1

gif1 ftgen 0, 0, 0, 1, gSfile, 0, 0, 1

gif2	hc_gen 0, 8192, 0, \ 
		hc_segment(1/92, 1, hc_hamming_curve()), \ 
		hc_segment(69/92, 0.04383, hc_cubic_curve()), \ 
		hc_segment(3/92, 0.09132, hc_power_curve(0.6143)), \ 
		hc_segment(18/92, 0, hc_toxoid_curve(0.20472))


	opcode cordelia_syncgrain, a, kkk
	kfreq, kpitch, kgrain_size xin

imax_overlaps 		init 8
ips     			init 1/imax_overlaps

istr    			init .25   /* timescale  */
;kpitch -- grain pitch scaling (1=normal pitch, < 1 lower, > 1 higher; negative, backwards)

aout				syncgrain 1/8, kfreq, kpitch, kgrain_size, ips*istr, gif1, gif2, imax_overlaps
	
	xout aout
	endop

    instr 1
kf = 5-(table:k(phasor:k(1/8), gif2, 1))
ktrig	metro kf
kndx init 0

if ktrig == 1 then
	kndx += 1
endif
kchange init 1

kval = 16 + int(24*abs(jitter(1, .0015, .005)))

if (kndx%kval)==0 then
	kchange = kchange + 1
	kndx = 1
endif

karr[] fillarray 0, 1, 0, 3, 2, 4, 5, 6, 5, 6, 7

kca1 = karr[kchange%8]
ktab	table 4+kca1+p4, gieuler_diat
aout cordelia_syncgrain kf, ktab/4, cosseg:k(1/4, p3, 1)
    outall aout

    endin
 
</CsInstruments>
<CsScore>
i 1 0 120 1
i 1 0 120 3
i 1 0 120 5
</CsScore>
</CsoundSynthesizer>