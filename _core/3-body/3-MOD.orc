;OPCODE
    opcode absolute_dist, a, ak
    ain, kp1 xin

setksmps 1

afx     balance2 abs(ain), ain
amod	abs lfo:a(1, kp1/2)

afx	*= (1-amod)
ain	*= amod

aout	= afx + ain

    xout aout
    endop
;OPCODE

	opcode  bbcutm_random, a, akk
	ain, ktime, kfb xin

kdel    = ktime

ibpm		i gkpulse
ibps		init ibpm/60
isubdiv		init 8 ;4, 8, 12 ..
ibarlength	init 4
iphrasebars	init 1
inumrepeats	init 9

istutterspeed	init 1
istutterchance	init 1
ienvchoice	init 1

aout        bbcutm ain, ibps, isubdiv, ibarlength, iphrasebars, inumrepeats, istutterspeed, istutterchance, ienvchoice

	xout aout
    	endop


;OPCODE
    opcode vcomb_balance, a, akkk
    ain, ktime, kfb, kmix xin

imax_t	init 15
acomb	vcomb ain, ktime, kfb*(imax_t/1000), imax_t
;acomb	balance2 acomb, ain

aout	= ain*(1-kmix) + acomb*kmix

    xout aout
    endop
;OPCODE
    opcode conv_1, a, aSik
    ain, String, ich, kmix xin

adest	chnget sprintf("%s_%i", String, ich)

aout    cross2 ain, adest, 4096, 2, gihanning, kmix
aout	balance2 aout, ain

    xout aout
    endop
;OPCODE

/*
	Args:  
	* asig : input signal
	* imaxdur : size of buffer in seconds
	* ksub : slicing subdivision
	* kchoice : which subdivision to use (not obvious it is useful)
	* kstutter : 1 for stutter, 0 for normal
	* kstutterspeed : speedy gonzales

*/

opcode jcut, a, akk
	asig, ksub, kchoice xin

	imaxdur init i(gkbeats)*4
	kstutter init 0
	ktrig init i(gkbeatn)
	ktrig = gkbeatn

	kkey, kdown sensekey
	if gkkeyboard_spacebar == 1 then 
		kstutter = (kstutter + 1 ) % 2
		kstutterspeed = int(random:k(1, 3))
	endif

	kchoice = kchoice % ksub
	kreach init 0

	if changed2(ktrig) == 1 then
		ksub_ch = changed2(ksub)
		kchoice_ch = changed2(kchoice)
		kstutter_ch = changed2(kstutter)
	endif
	
	ilen_smps = imaxdur * sr
	ibuf ftgentmp 0, 0, ilen_smps, -2, 0
	
	kstut_sub init 1
	kstut_rpos init 0
	if(kstutter_ch > 0) then 
		kstut_sub = ksub
		kstut_rpos = 0
	endif

	kstut_limit = int(ilen_smps / kstut_sub)
	ibuf_stutter ftgentmp 0, 0, ilen_smps, -2, 0

	kwrite_ptr init 0
	
	asig init 0

	kcnt = 0
	while kcnt < ksmps do 
		tablew(asig[kcnt], kwrite_ptr, ibuf)
		kwrite_ptr = (kwrite_ptr + 1) % ilen_smps
		kcnt += 1
	od

	kincr init 0
	kinit init 1
	if(kinit == 1  || kchoice_ch > 0 || ksub_ch > 0 ) then
		kplus = ilen_smps / ksub * kchoice
		kread_ptr = (kwrite_ptr + kplus) % ilen_smps
		kincr = 0
	endif
	kreach = 0

	kcnt = 0
	if(kstutter > 0) kgoto stutter

	kinit = 0
	while kcnt < ksmps do 
		aout[kcnt] = table(  (kread_ptr + kincr) % ilen_smps, ibuf)	
		kincr = (kincr + 1) % int(ilen_smps / ksub) 
		// Write for stutter
		tablew(aout[kcnt], kincr, ibuf_stutter)
		if(kincr == 0) then 
			kreach = 1
		endif

		
		kcnt += 1 
	od
	kgoto nostutter

	stutter:
	kcnt = 0
	while kcnt < ksmps do 
		aout[kcnt] = table(kstut_rpos, ibuf_stutter)
		kstut_rpos = (kstut_rpos + kstutterspeed) % int(ilen_smps / kstut_sub)
		kcnt += 1		
	od

	nostutter:
	
	xout aout
endop
;OPCODE

    opcode delay_array, a, akki
    
    setksmps 1
    adel_in, kdel_time, kfb, instances xin

idel_buf    init 10

adel_dump   delayr idel_buf
adel_tap    deltap kdel_time
            delayw adel_in + (adel_tap * kfb)

adel_out    limit adel_tap, -1, 1

if instances > 1 then
    adel_out += delay_array(adel_out, kdel_time + .15, kfb, instances-1)
endif

adel_out    limit adel_out, -1, 1
    
    xout adel_out
    
    endop;OPCODE
    opcode duck, a, aSik
    ain, Sinstr, ich, kmix xin

aenv    follow2 chnget:a(sprintf("%s_%i", Sinstr, ich)), 25$ms, 95$ms
afol	= ain * (1-aenv)

aout	= afol*kmix + ain*(1-kmix)

    xout aout
    endop

;OPCODE
    opcode moogladder_balance, a, akk
    ain, kfreq, kq xin

ifreq_var	init 5
aout	moogladder2 ain, kfreq+randomi:k(-ifreq_var, ifreq_var, .05), kq
aout	balance2 aout, ain

    xout aout
    endop
;OPCODE
    opcode cordelia_pconvolve, a, aiki
    ain, ir, kmix, ich xin

SFiles[]        directory "/Users/j/Documents/PROJECTs/CORDELIA/_setting/_IR", ".wav"

inchnls         filenchnls SFiles[ir]
;inchnls         init 2

ichnl_array     init (ich%inchnls)+1

aconv           pconvolve ain, SFiles[ir], 0, ichnl_array

aout            = aconv*kmix + ain*(1-kmix)

    xout aout

    endop
;OPCODE

giplate_rev_tabexcite	ftgen 0, 0, 0, -2, .35, .3875, .392575, .325, .85715, .78545
giplate_rev_tabouts	ftgen 0, 0, 0, -2, .25, .675, 1.50975, .25, .75, .51545

	opcode plate_rev, a, ak
	ain, kmix xin

itime init i(gkbeats)*8 

arev	platerev giplate_rev_tabexcite, giplate_rev_tabouts, 0, 0.095, .75, itime, 0.0015, ain
aout	= ain*(1-kmix) + arev*kmix

	xout aout
	endop
;OPCODE


	opcode reverb_1, a, akkk
	ain, ktime, khigh_freq, kmix xin

arev	nreverb ain, ktime, 1-khigh_freq
aout	= ain*(1-kmix) + arev*kmix

	xout aout
	endop
;OPCODE
	opcode ringmod_heart, a, akk
	ain, kdiv, ktab xin

kphase		= kdiv - floor(kdiv)
kndx		= ((chnget:k("heart")*kdiv*gkdiv)+kphase)%1
kring		tableikt kndx, ktab, 1, 0, 1

aout		= ain * a(kring)

	xout aout
	endop
;OPCODE
    opcode cordelia_skh, a, akk
    ain, kfreq, kq xin

ifreq_var	init 5
aout	skf ain, kfreq+jitter:k(ifreq_var, gkbeatf/8, gkbeatf), 1+(kq*3), 1
aout	balance2 aout, ain

    xout aout
    endop
;OPCODE
    opcode cordelia_skl, a, akk
    ain, kfreq, kq xin

ifreq_var	init 5
aout	skf ain, kfreq+jitter:k(ifreq_var, gkbeatf/8, gkbeatf), 1+(kq*3), 0
aout	balance2 aout, ain

    xout aout
    endop
;OPCODE

/* Solina Chorus, based on Solina String Ensemble Chorus Module
  
   based on:

   J. Haible: Triple Chorus
   http://jhaible.com/legacy/triple_chorus/triple_chorus.html

   Hugo Portillo: Solina-V String Ensemble
   http://www.native-instruments.com/en/reaktor-community/reaktor-user-library/entry/show/4525/ 

   Parabola tabled shape borrowed from Iain McCurdy delayStereoChorus.csd:
   http://iainmccurdy.org/CsoundRealtimeExamples/Delays/delayStereoChorus.csd

   Author: Steven Yi
   Date: 2016.05.22

   */

	gi_solina_parabola ftgen 0, 0, 65537, 19, 0.5, 1, 180, 1 

	;; 3 sine wave LFOs, 120 degrees out of phase
	opcode sol_lfo_3, aaa, kk
	kfreq, kamp xin

aphs	phasor kfreq

a0		tablei aphs, gi_solina_parabola, 1, 0, 1
a120	tablei aphs, gi_solina_parabola, 1, 0.333, 1
a240	tablei aphs, gi_solina_parabola, 1, -0.333, 1

	xout (a0 * kamp), (a120 * kamp), (a240 * kamp)
	endop

	opcode solina_chorus, a, akk

	aLeft, klfo_freq1, klfo_amp1 xin

klfo_freq2 = klfo_freq1*3
klfo_amp2 = klfo_amp1*3

imax = 100

;; slow lfo
as1, as2, as3 sol_lfo_3 klfo_freq1, klfo_amp1

;; fast lfo
af1, af2, af3  sol_lfo_3 klfo_freq2, klfo_amp2

at1 = limit(as1 + af1 + 5, 0, imax)
at2 = limit(as2 + af2 + 5, 0, imax)
at3 = limit(as3 + af3 + 5, 0, imax)
	
a1 vdelay3 aLeft, at1, imax 
a2 vdelay3 aLeft, at2, imax 
a3 vdelay3 aLeft, at3, imax 

	xout (a1 + a2 + a3) / 3
	endop;OPCODE


	opcode cor_streason, a, akk
	ain, kfreq, kq xin

kfreq += oscili:k(.5, gkbeatf/64)

aguid	wguide1 ain, 1/kfreq, kfreq/2, kq

astr1	streson ain, kfreq, kq
astr2	streson ain, kfreq*1.25, kq

aout	= aguid + astr1 + astr2
aout	/= 3

aout	phaser1 aout, kfreq, 12, kq
	
	xout aout
	endop
;OPCODE


	opcode cor_streason_p, a, akkk
	ain, kfreq, kport, kq xin

kfreq	portk kfreq, kport

aguid	wguide1 ain, 1/kfreq, kfreq/2, kq

astr1	streson ain, kfreq, kq
astr2	streson ain, kfreq*1.25, kq

aout	= aguid + astr1 + astr2
aout	/= 3

aout	phaser1 aout, kfreq, 12, kq
	
	xout aout
	endop
;OPCODE

; Original research and code by Jon Downing  as in paper
; Real-time digital modeling of the Roland Space Echo by Jon Downing, Christian Terjesen (ECE 472 - Audio Signal Processing, May 2016)
;
; Reimplemented in Csound by Anton Kholomiov

; Error function approximation ~ 2% accuracy
opcode ErrorFunApprox, a, a
  aIn xin
  kCoeff init ( (3.1415926535 ^ 0.5) * log(2) )
  xout tanh(kCoeff * aIn)
endop

; Bandpass Chebyshev Type I filter
opcode bandpassCheby1, a, akkii
  aIn, kLowFreq, kHighFreq, iOrder, iRipple xin

  aHigh clfilt aIn,   kLowFreq,  1, iOrder, 1, iRipple
  aLow  clfilt aHigh, kHighFreq, 0, iOrder, 1, iRipple

  xout aLow
endop

; Function to read from tape.
;
; tapeRead aIn, kDelay, kRandomSpread
;
; The function is used in the same manner as deltapi
; first init the delay buffer and the use tapeRead.
;
; aIn - input signal
; kDelay - delay time
; kRandomSpread - [0, Inf] - the random spread of reading from the tape
;    the higher the worser the quality of the tape.
opcode tapeRead, a, akk
  aIn, kDelay, kRandomSpread xin
  iTauUp = 1.07
  iTauDown = 1.89
  aPrevDelay init 0.06
  kOldDelay  init 0.06
  kLambda init 0.5

  kDelChange changed2 kDelay
  if (kDelChange == 1) then
    if (kOldDelay < kDelay) then
      kLambda = exp(-1/(iTauUp*sr))
    else
      kLambda = exp(-1/(iTauDown*sr))
    endif
  endif

  anoise noise kRandomSpread, 0
  anoise = 3*(7.5 - aPrevDelay*(10^-3))*(10^-7)*anoise
  anoiseMod butterlp anoise, 0.25  ; (0.5 / sr) * giNyquistFreq
  aActualDelay = (1 - kLambda) * kDelay + kLambda * aPrevDelay + anoiseMod
  aPrevDelay = aActualDelay
                                         ; measured
  aDelaySamps = aActualDelay * sr
  aReadSr = floor(aDelaySamps)          ; in samples
  aLastSr = aReadSr + 1                 ; in samples
  aReadIndex = aReadSr / sr             ; in seconds
  aLastIndex = aLastSr / sr             ; in seconds
  aFrac = aDelaySamps - aReadSr
  aFracScale = (1 - aFrac) * (1 + aFrac)

  aReadSample deltapi aReadIndex
  aLastSample deltapi aLastIndex

  aEcho ErrorFunApprox (aLastSample + aFracScale * (aReadSample - aLastSample))

  kOldDelay = kDelay
  xout aEcho
endop

; function to write to tape
;
; tapeWrite aIn, aOut, kFbGain
;
; It should be though of as delayw for magnetic tape.
;
; aIn - input signal
; aOut - output signal
; kFbGain - gain of feedback [0, 2]
opcode tapeWrite, 0, aak
  aIn, aOut, kFbGain xin
  iOrder    = 2
  iRippleDb = 6
  aProc bandpassCheby1 aOut * kFbGain, 95, 3000, iOrder, iRippleDb
  delayw aIn + aProc * kFbGain
endop

; Simple tape delay effect with tone-color.
;
; aIn - input signal
; kDelay - delay time
; kEchoGain - gain for the echo
; kFbGain - feedback gain
; kTone - color of the low-pass filter (frequency for the filter)
; kRandomSpread - radius of noisy reading from the tape [0.5, Inf] - relates to "tape age".
;   smaller - the better tape is
opcode TapeEcho1, a, akkkkk
  aIn, kDelay, kEchoGain, kFbGain, kTone, kRandomSpread xin

  aDummy delayr 16
  aEcho tapeRead aIn, kDelay, kRandomSpread
  aOut  = aIn + kEchoGain * aEcho

  aOut tone aOut, kTone
  tapeWrite aIn, aOut, kFbGain
  xout aOut
endop


opcode TapeEcho3, a, akkkkk
  aIn, kDelay, kEchoGain, kFbGain, kTone, kRandomSpread xin

  aDummy delayr 16
  aEcho1 tapeRead aIn, kDelay, kRandomSpread
  aEcho2 tapeRead aIn, (kDelay * 2), kRandomSpread
  aEcho3 tapeRead aIn, (kDelay * 4), kRandomSpread
  aOut  = aIn + kEchoGain * aEcho1 + 0.5 * kEchoGain * aEcho2 + 0.25 * kEchoGain * aEcho3

  aOut tone aOut, kTone
  tapeWrite aIn, aOut, kFbGain
  xout aOut
endop

opcode TapeEcho4, a, akkkkk
  aIn, kDelay, kEchoGain, kFbGain, kTone, kRandomSpread xin

  aDummy delayr 16
  aEcho1 tapeRead aIn, kDelay, kRandomSpread
  aEcho2 tapeRead aIn, (kDelay * 2), kRandomSpread
  aEcho3 tapeRead aIn, (kDelay * 4), kRandomSpread
  aEcho4 tapeRead aIn, (kDelay * 8), kRandomSpread
  aOut  = aIn + kEchoGain * aEcho1 + 0.5 * kEchoGain * aEcho2 + 0.25 * kEchoGain * aEcho3  + 0.2 * kEchoGain * aEcho4

  aOut tone aOut, kTone
  tapeWrite aIn, aOut, kFbGain
  xout aOut
endop


opcode tapeReadBatch, a, akkii
  aIn, kDelay, kRandomSpread, iSize, iStart xin

  if iStart <= iSize then
    acall tapeReadBatch aIn, kDelay, kRandomSpread, iSize, iStart + 1
  else
    acall = 0
  endif

  iScale = iStart
  aEcho tapeRead aIn, kDelay * iScale, kRandomSpread
  xout acall + aEcho / iScale
endop

opcode TapeEchoN, a, akkkkki
  aIn, kDelay, kEchoGain, kFbGain, kTone, kRandomSpread, iSize xin
  aDummy delayr (16 * iSize)
  aEcho tapeReadBatch aIn, kDelay, kRandomSpread, iSize, 1
  aOut = aIn + kEchoGain * aEcho
  tapeWrite aIn, aOut, kFbGain
  xout aOut
endop


opcode  cor_tape_del, a, akkk
ain, ktime, kfb, kgain xin

kdel    = ktime
kgain	init 1
kvar	oscili .25, gkbeatf/8


aout	TapeEchoN ain*kgain, kdel, kfb, .95, 0, .75 + kvar, 10

  xout aout

    endop


