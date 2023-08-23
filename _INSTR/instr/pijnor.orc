maxalloc	"pijnor", 10	;maximum polyphony
;prealloc	1, 9 ;preallocate voices
gapijnor_inrev	init	0
gipijnor_adsr ftgen 0, 0, 256, -25, 0, 0.000006, 12, 0.000025, 24, 0.0001, 36, 0.000398, 48, 0.001584, 60, 0.006309, 72, 0.02511, 84, 0.1, 96, 0.398107, 108, 1.5848931, 120, 6.3095734, 132, 25.1188, 144, 100.0, 156, 398.10, 168, 1584.89, 256, 2000
gipijnor_ptof ftgen 0, 0, 512, -25, 0, 0.00012475, 12, 0.00024951, 24, 0.00049901, 36, 0.00099802, 48, 0.00199604, 60, 0.00399209, 72, 0.00798418, 84, 0.01596836, 96, 0.03193671, 108, 0.06387343, 120, 0.12774686, 132, 0.25549372, 144, 0.51098743, 156, 1.02197486, 168, 2.04394973, 180, 4.08789946, 192, 8.17579892, 204, 16.3515978, 216, 32.7031957, 228, 65.4063913, 240, 130.812783, 252, 261.625565, 264, 523.251131, 276, 1046.50226, 288, 2093.00452, 300, 4186.00904, 312, 8372.01809, 324, 16744.0362, 336, 33488.0724, 348, 66976.1447, 360, 133952.289, 372, 267904.579, 384, 535809.158, 396, 1071618.32, 512, 100

gipijnor_ftrev1 ftgen 0, 0, 128, -25, 0, 0.00227272727, 128, 3.69431518
gipijnor_ftrev2 ftgen 0, 0, 128, -25, 0, 8.17579892, 128, 13289.7503

opcode	pijnor_opinstr, a, iiiiiiikkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk

iPitch,\			;midi pitch
\;AIR ENV
iAtt_ENV,\		;knob Att
iDec_ENV,\		;knob Dec
iSus_ENV,\		;knob Sus
iRel_ENV,\		;knob Rel
iVel_ENV,\		;knob Vel
iScaling_ENV,\		;knob Scaling
\;AIR GEN
kDC_Noise_GEN,\	;knob DC/Noise
kCut_GEN,\		;knob Cut
kRes_GEN,\		;knob Res
kK_Track_GEN,\		;knob K-Track
kV_Track_GEN,\		;knob V-Track
k1_Pole_GEN,\		;button 1-Pole
\;Pipe
kCtr_MW,\			;knob ModWheel
kPolarity,\		;button Polarity
\;Pipe DELTUNE
kTune_DT,\		;knob Tune
kFine_DT,\		;knob Fine
kSREC_DT,\		;knob Srec
kMW_DT,\			;knob MW
\;Pipe FEEDBACK
kRT_FB,\			;knob RT
kK_TrackFB,\		;knob K-Track
kDamp_FB,\		;knob Damp
\;Pipe ALLPASS TUNE
kTune_AP,\		;knob Tune
kFine_AP,\		;knob Fine
kSREC_AP,\		;knob Srec
kMW_AP,\			;knob MW
\;Pipe ALLPASS
kDffs_AP,\		;knob Dffs
kPower_AP,\		;button Power
\;Pipe PUSH PULL
kOffset,\			;knob Offset
kPush,\			;knob Push
\;Pipe SATURATION
kSoftHard,\		;knob Soft/Hard
kSym,\			;knob Sym
\;Pipe MW FILTER
kHP0,\			;knob HP0
kHP1,\			;knob HP1
kK_TrackH,\		;knob K-TrackH
kLP0,\			;knob LP0
kLP1,\			;knob LP1
kK_TrackL\		;knob K-TrackL
		xin

;		setksmps	1
;******************************************************************************************AIR SECTION
;Input iPitch
;Output aout_Air (to PIPE)
;************************************************************************************************ENV
;Output kout_ENV (to GEN)
iScaling_ENV	= iScaling_ENV * (iPitch - 60)
iAtt_ENV	= iAtt_ENV + iScaling_ENV
iDec_ENV	= iDec_ENV + iScaling_ENV
iRel_ENV	= iRel_ENV + iScaling_ENV
iGate_ENV	= 1 - 0.5 * iVel_ENV

iAtt_ENV	table	iAtt_ENV + 44, gipijnor_adsr		;exp table; add 44 for positive index
iDec_ENV	table	iDec_ENV + 44, gipijnor_adsr		;exp table; add 44 for positive index
iRel_ENV	table	iRel_ENV + 44, gipijnor_adsr		;exp table; add 44 for positive index

iRel_ENV	= iRel_ENV * 6

		xtratim	iRel_ENV + 0.1

krel_ENV	init	0

krel_ENV	release									;outputs release-stage flag
		if   (krel_ENV > .5)	kgoto	rel_ENV		;if in release-stage goto release section
;attack decay and sustain
kmp1_ENV	transeg	0.001, iAtt_ENV, 0, iGate_ENV, iDec_ENV*10,-10, iGate_ENV * iSus_ENV, 1, 0, iGate_ENV * iSus_ENV
kout_ENV	= kmp1_ENV
		kgoto	done_ENV
;release
rel_ENV:
kmp2_ENV	transeg	1, iRel_ENV, -6, 0.0024787521
kout_ENV	= kmp2_ENV * kmp1_ENV

done_ENV:
;kout_ENV is envelope
;************************************************************************************************GEN
;Input kout_ENV (output from ENV)
;Output aout_Air (to PIPE section)

;iPitch_GEN from -48 to +168
kPitch_GEN	= ((iPitch - 60) * kK_Track_GEN + kCut_GEN) * (1 - (0.5 * kV_Track_GEN))

kCut_GEN	table	kPitch_GEN + 192, gipijnor_ptof	;exp table; add 192 for positive index

anoise_GEN	noise	kout_ENV, 0

	if (k1_Pole_GEN < 0.5)	kgoto Deux_Pole_GEN

;One pole filter LPF1
i2Pisr		= 2*$M_PI/sr
kPhic_GEN	= (kCut_GEN < 6948.89 ? i2Pisr * kCut_GEN : 0.99005)

;LP
aout_LPF	biquad	anoise_GEN, kPhic_GEN, 0, 0, 1, kPhic_GEN-1, 0

		kgoto	Done_GEN
Deux_Pole_GEN:
;Two poles filter LPF2
kRes_GEN	= 0.5  / (1 - kRes_GEN)

aout_LPF	lowpass2	anoise_GEN, kCut_GEN, kRes_GEN

Done_GEN:
aout_Air	= aout_LPF * kDC_Noise_GEN + a(kout_ENV) *  (1 - kDC_Noise_GEN)

;*******************************************************************************************PIPE SECTION
;Input aout_Air (output from AIR)
;Output aout_Pipe (to AMPLI)
;*******************************************************************************************DEL TUNE
;Output idly_DT (to SINGLE DELAY and FEEDBACK)

;iPitch_DT from -27 to +147
kPitch_DT		= iPitch + kTune_DT + kFine_DT + kCtr_MW * kMW_DT
kFreq_DT		table	kPitch_DT + 192, gipijnor_ptof		;exp table; add 192 for positive index
kdly_DT		= (1/kFreq_DT)+( kSREC_DT/sr)

;************************************************************************************SINGLE DELAY
;Input idly_DT (output from DEL TUNE)
;Input aout_FeedBack (output from FEEDBACK)
;Output aout_SD  (to ALLPASS)

aout_FeedBack	init	0

amaxtime_SD	delayr	1			;set maximum delay
aout_SD		deltap3	 kdly_DT
			delayw	aout_FeedBack

;Send the signal aout_SD to Saturation (Allpass is bypassed) if iPower_AP = 0.

if kPower_AP > 0.5	kgoto	Allpasstune

aout_AP	= aout_SD
		kgoto Saturation
Allpasstune:
;************************************************************************************ALLPASS TUNE
;Output idly_APTune (to ALLPASS)

;iPitch_AP from -27 to +147
kPitch_AP		= iPitch + kTune_AP + kFine_AP + kCtr_MW * kMW_AP
kFreq_AP		table	kPitch_AP + 192, gipijnor_ptof			;exp table; add 192 for positive index
kdly_APTune	= (1/kFreq_AP)+( kSREC_AP/sr)

;******************************************************************************************ALLPASS
;Input aout_SD (from SINGLE DELAY)
;Input idly_APTune (from ALLPASS TUNE)
;Output aout_AP  (to SATURATION)

;Interp Diffusion	;atime mini=1/sr
adel1_APA	init	0

amaxtime_APA	delayr	0.2						;set maximum delay
aout_AP		= adel1_APA + kDffs_AP * aout_SD		;FEED FORWARD
adel1_APA		deltap3	kdly_APTune				;DELAY
			delayw	aout_SD - kDffs_AP * aout_AP	;FEEDBACK
Saturation:
;**************************************************************************************SATURATION
;Input aout_AP  (from ALLPASS)
;Output aout_Sat  (to MW FILTER)

;Event Clip
kSoftHard_Clip	= ( kSoftHard == 0 ? 0.00001 : kSoftHard)
kSoftHard_Clip = ( kSoftHard == 1 ? 0.99999 : kSoftHard)

kSHS		= kSoftHard_Clip * kSym
kMaxClipper	= kSHS +  kSoftHard_Clip
kMinClipper	= kSHS -  kSoftHard_Clip

aoutClip	limit	aout_AP, kMinClipper, kMaxClipper

;Positive signal
kSat_coefPlus	= 0.5 * (1 + kSym - kMaxClipper)
;Saturator
ain_SatPlus	= (aout_AP - aoutClip) / kSat_coefPlus
;Clipper (to limit output to +2, when input is > +4)
ain_SatPlus	limit	ain_SatPlus, 0, 4							;Positive clip and remove negative signal
aSat_outPlus	= (-0.125 * ain_SatPlus * ain_SatPlus) + ain_SatPlus		;Out=-0.125*In*In+In if In>0 ; In = 4 -> Out = 2

;Negative signal
kSat_coefMoins	= 0.5 * (1 - kSym + kMinClipper)
;Saturator
ain_SatMoins	= (aout_AP - aoutClip) / kSat_coefMoins
;Clipper (to limit output to -2, when input is <-4)
ain_SatMoins	limit	ain_SatMoins, -4, 0							;Negative clip and remove negative signal
aSat_outMoins	= (0.125 * ain_SatMoins * ain_SatMoins) + ain_SatMoins		;Out=0.125*In*In+In if In<0  ; In = -4 -> Out = -2

aout_Sat	= (aSat_outPlus * kSat_coefPlus) +  (aSat_outMoins * kSat_coefMoins) + aoutClip

;*****************************************************************************************MW FILTER
;Input aout_Sat  (from SATURATION)
;Output aout_Pipe (to AMPLI, FEEDBACK, PUSH PULL)

;HPF1
;iPitch_MWHP from -48 to +168
kPitch_MWHP	= (iPitch-60) * kK_TrackH + (1- kCtr_MW) * kHP0 + kCtr_MW * kHP1
kFreq_MWHP	table	kPitch_MWHP + 192, gipijnor_ptof						;exp table; add 192 for positive index
kPhic_MWHP	= (kFreq_MWHP < 6948.89 ? i2Pisr * kFreq_MWHP : 0.99005)

aout_HPF1	biquad	aout_Sat, 1, -1, 0, 1, kPhic_MWHP-1, 0

;LPF1
;iPitch_MWLP from -48 to +168
kPitch_MWLP	= (iPitch-60) * kK_TrackL + (1- kCtr_MW) * kLP0 + kCtr_MW * kLP1
kFreq_MWLP	table	kPitch_MWLP + 192, gipijnor_ptof						;exp table; add 192 for positive index
kPhic_MWLP	= (kFreq_MWLP < 6948.89 ? i2Pisr * kFreq_MWLP : 0.99005)

aout_Pipe	biquad	aout_HPF1, kPhic_MWLP, 0, 0, 1, kPhic_MWLP-1, 0

;******************************************************************************************PUSH PULL
;Input aout_Air (from AIR)
;Input aout_Pipe  (from MW FILTER)
;Output aout_PPull (to FEEDBACK)

aout_PPull	= (aout_Pipe * kPush + kPolarity * kOffset) * aout_Air

;******************************************************************************************FEEDBACK
;Input aout_Pipe  (from MW FILTER)
;entrée kdly_DelTune (from DEL TUNE)
;Output aout_FeedBack (to SINGLE DELAY)

;Midi to freq conversion (note 69 = 440Hz)
;Cannot use cpsoct (P/12 + 3) because P can go below -36
kPitch_FB	= (iPitch - 60) * kK_TrackFB  + kRT_FB
kFreq_FB	table	kPitch_FB + 192, gipijnor_ptof								;exp table; add 192 for positive index
kLevel_FB	= 60.0 * (1 - kdly_DT * kFreq_FB)
kLevel_FB	= 0.001 * ampdb(kLevel_FB)

kPitch_FB_Rel	= kPitch_FB + kDamp_FB
kFreq_FB_Rel	table	kPitch_FB_Rel + 192, gipijnor_ptof						;exp table; add 192 for positive index
kLevel_FB_Rel	= 60.0 * (1 - kdly_DT * kFreq_FB_Rel)
kLevel_FB_Rel	= 0.001 * ampdb(kLevel_FB_Rel)

		if   (krel_ENV > .5)	kgoto	Rel_FB
aout_FBack	= aout_Pipe * kLevel_FB
		kgoto	done_FB
Rel_FB:
aout_FBack	= aout_Pipe * kLevel_FB_Rel

done_FB:
aout_FeedBack	= (aout_FBack + aout_PPull) * kPolarity
;*****************************************************************************************PIPE SECTION END
		xout	aout_Pipe
endop

    instr	pijnor	;Pipe (physical waveguide)

Sinstr		init "pijnor"
idur		init p3
idyn		init p4
ienv		init p5
icps		ftom p6
ich			init p7

;ctrl reading
;ENV

itot            init 20+29+28
iAtt_ENV		init idur/(20/itot)
iDec_ENV		init idur/(29/itot)
iSus_ENV		init 0
iRel_ENV		init idur/(28/itot)
iVel_ENV		init .45
iScaling_ENV	init 0
;GEN
kDC_Noise_GEN	init .795
kCut_GEN		init 91.25
kRes_GEN		init 0
kK_Track_GEN	init 1.35
kV_Track_GEN	init .35
k1_Pole_GEN     init 0
;Pipe
kCtr_MW		    init 0
iPolarity		init 1
;Pipe DELTUNE
kTune_DT		init 26.45
kFine_DT		init -.245
kSREC_DT		init -1.65
kMW_DT		init 2
;Pipe FEEDBACK
kRT_FB		init -7.25
kK_TrackFB	init 1.265
kDamp_FB	init 0
;Pipe ALLPASS TUNE
kTune_AP	init 1.25
kFine_AP	init .145
kSREC_AP	init -1.25
kMW_AP		init 2
;Pipe ALLPASS
kDffs_AP	init .425
kPower_AP	init 1
;Pipe PUSH PULL
kOffset		init .85
kPush		init 1.245
;Pipe SATURATION
kSoftHard		init .65
kSym			init .125
;Pipe MW FILTER
kHP0			init 0
kHP1			init 0
kK_TrackH		init 1.425
kLP0			init 109.25
kLP1			init 102
kK_TrackL		init .325

kMain_Vol		init $dyn_var

iPitch          init icps

kPolarity		= 1 - 2*iPolarity

aout_Pipe		pijnor_opinstr	iPitch, iAtt_ENV, iDec_ENV, iSus_ENV, iRel_ENV, iVel_ENV, iScaling_ENV, kDC_Noise_GEN, kCut_GEN, kRes_GEN, kK_Track_GEN, kV_Track_GEN, k1_Pole_GEN, kCtr_MW, kPolarity, kTune_DT, kFine_DT, kSREC_DT, kMW_DT, kRT_FB, kK_TrackFB, kDamp_FB, kTune_AP, kFine_AP, kSREC_AP, kMW_AP, kDffs_AP, kPower_AP, kOffset, kPush, kSoftHard, kSym, kHP0, kHP1, kK_TrackH, kLP0, kLP1, kK_TrackL

aout	= gapijnor_inrev + aout_Pipe * kMain_Vol

    $CHNMIX
    
    


