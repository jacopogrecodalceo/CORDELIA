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
-odac
</CsOptions>
<CsInstruments>

;sr		=	192000
sr		=	48000
0dbfs		=	1

ksmps		=	2	;leave it at 64 for real-time
;nchnls_i	=	12
nchnls		=	2
;A4		=	438	;only for ancient music	
gSfile init "/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/armagain.wav"
gilen filelen gSfile

gif1 ftgen 0, 0, 0, 1, gSfile, 0, 0, 1

gif2	hc_gen 0, 8192, 0, \ 
		hc_segment(1/92, 1, hc_hamming_curve()), \ 
		hc_segment(69/92, 0.04383, hc_cubic_curve()), \ 
		hc_segment(3/92, 0.09132, hc_power_curve(0.6143)), \ 
		hc_segment(18/92, 0, hc_toxoid_curve(0.20472))


	opcode cordelia_syncgrain, a, kk
	kfreq, kpitch xin

imax_overlaps 		init 8
kgrain_size			init 1/2
ips     			init 1/imax_overlaps

istr    			init .25   /* timescale  */
;kpitch -- grain pitch scaling (1=normal pitch, < 1 lower, > 1 higher; negative, backwards)

aout				syncgrain .5, kfreq, kpitch, kgrain_size, ips*istr, gif1, gif2, imax_overlaps
	
	xout aout
	endop

    instr 1


aout cordelia_syncgrain 15*lfo(1, .005), .25

    outall aout

    endin
 
</CsInstruments>
<CsScore>
i 1 0 60
</CsScore>
</CsoundSynthesizer>