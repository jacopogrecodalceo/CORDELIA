<CsoundSynthesizer>
<CsOptions>
; ============
; *** INs ***
; ============
;--input=adc
;--nchnls_i=1

; ============
; *** OUTs ***
; ============
-odac
--nchnls=2

; ============
; *** RT ***
; ============
;-+rtaudio=auhal

; ============
; *** KSMPs ***
; ============
--ksmps=64

; ============
; *** BUFs ***
; ============
;--iobufsamps=64
;--hardwarebufsamps=256

; ============
; *** SR ***
; ============
--sample-rate=48000

; ============
; *** OPTs ***
; ============
--0dbfs=1
--format=24bit
;--limiter
;-Ma

; ============
; *** ENVs ***
; ============
;--env:SSDIR+=./sonvs/

; ============
; *** MSGs ***
; ============
--m-amps=1
--m-range=1
--m-warnings=0
--m-dB=1
--m-colours=1
--m-benchmarks=0

; ============
; *** INFO ***
; ============
-+id_artist="jacopo greco d'alceo"
</CsOptions>
<CsInstruments>

;gSfile init "/Users/j/Desktop/cor241126-1556/cor241126-1556-mouth.wav"
gSfile init "/Users/j/Documents/PROJECTs/mélanines/version/03-rosso_cremisi.wav"

; ============
; Create as many GENs as channels
; ============
ich			filenchnls gSfile
indx		init 1
until indx > ich do
	itab ftgen indx, 0, 0, 1, gSfile, 0, 0, indx
	print indx
	indx += 1
od

gifn_len	init 8192
gisquare	ftgen	0, 0, gifn_len, 7, 1, gifn_len/2, 1, 0, -1, gifn_len/2, -1

		instr 1
; ============
; *** INIT ***
; ============
ifn			init p4
ich			init p4
ilen_file	init ftlen(ifn)/ftsr(ifn)

; ============
; *** VARs ***
; ============
ispeed 		init 1 ; [idur*ispeed]
kport		= 0
; ============
p3			init ilen_file*ispeed
idur		init p3
; ============

; ============
; *** READ ***
; ============
atime		phasor 1/idur
ain			table3 atime, ifn, 1

kcps, krms pitchamdf ain, 35, 2500

kfreq_samphold = 1.5+krms*35

;===================
kord 		init 425
;===================
;kfeedback 	init .95
kfeedback 	= .15 + abs(oscil3(.75+jitter(.05, 1, 3), kfreq_samphold/2, gisquare))
anotch		phaser1 ain, samphold:k(kcps, metro(kfreq_samphold)), kord, kfeedback
anotch		= (ain / 12 - anotch) / 2

adelx			init 0
kdel_t_temp		= 1/samphold:k(kcps, metro(kfreq_samphold))*16
kdel_t			init 0
if kdel_t_temp > 1/12 then
	kdel_t = kdel_t_temp
endif

while kdel_t > 5 do
	kdel_t /= 2
od

adelx		vdelayx anotch+adelx*(1-kfeedback), a(kdel_t), 5, 4096

asum		sum anotch, adelx / 8

aout		butterhp asum, 20

		outch ich, aout

		endin


;---SCORE---
/* 
for i in range(1):
	code = [
		'i1',
		0,			# p2: when
		1,			# p3: dur
		ch			# p4
	]
	score.append(' '.join(map(str, code)))
*/


</CsInstruments>

<CsScore>
i 1 0 1 1
i 1 0 1 2
e
</CsScore>

</CsoundSynthesizer>