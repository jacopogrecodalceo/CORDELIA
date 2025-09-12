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
--ksmps=1024

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
; *** WINDOWS ***
; ============
gihanning		ftgen 0, 0, 8192, 20, 2

; ============
; *** TABs ***
; ============
ich     filenchnls gSfile
indx    init 0
until indx == ich do
	inum init indx + 1
	itab ftgen inum, 0, 0, 1, gSfile, 0, 0, inum
	indx += 1
od

	instr 1

ich     init p4
idur    init ftlen(ich)/sr

; ============
; *** INIT ***
; ============
/*
The fundamental analysis parameters are input frame size and filter order.
Longer input frames will produce a more accurate result in terms of frequency resolution,
but will also involve more computation. 
This is due to the computation of the autocorrelation function, which is then used in the coefficient computation. 
This part is more efficient and depends only on the linear prediction order,
which is also the number of coefficients computed.
Typical lp orders may range from about 30 to 100 coefficients, but larger values can also be used.
 */

ispeed	init 1
isize	init 8192
iord	init isize/2

p3		init idur*ispeed

kport   abs jitter(1/12, 1/12, 1)
kspeed  = 1/ispeed

kread   init 0
kcfs[], krms, kerr, kf lpcanal kread, 1, ich, isize, iord, gihanning

kf			init 0
kf_temp		init 0
kf_last		init 0

if kf != kf_temp then
	kf_last = kf_temp
endif
kf_temp = kf

kn_harm = sr/2/kf

a1      buzz 0dbfs, portk(kf, kport), kn_harm, -1
a2      vco2 4*(krms*kerr), kf_last

asum	sum a1, a2
aout	allpole asum*krms*kerr, kcfs

kread      += ksmps*kspeed  

if kread > ftlen(ich) then
	kread = 0
endif 

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