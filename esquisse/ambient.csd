<CsoundSynthesizer>
<CsOptions>
-d -odac -W -3 
</CsOptions>
<CsInstruments>
sr = 192000
ksmps = 1
nchnls = 2
0dbfs = 1

seed 0
gSdir = "/Users/j/Documents/PROJECTs/CORDELIA/samples/tape"
;-----------------------------------------------------------
instr 1
giLowestLoopSpeed = 0.125
giMaxLoopSpeed = 1.1
iCounter = 0
iloopAmp init -6
iloopSpeed = (giLowestLoopSpeed+giMaxLoopSpeed)/2
ipanPos init 0.5
iPanSpeed init 0.01
iStart init 0
iInstances random 4, 11
while iCounter < iInstances do
	schedule 100, iStart, p3, iloopSpeed, iloopAmp, iPanSpeed
	iloopSpeed random giLowestLoopSpeed, giMaxLoopSpeed ; Loop Speed Inkrement
	iloopAmp += +1
	iPanSpeed random 0.01, 0.2
	iCounter += 1
od
endin

instr 100 ; Soundfile Looper with playbackspeed change and panning
kSpeed init p4
; Lese einen Ordner auf .wav aus
iCount init 0
SFilenames[] directory gSdir, ".wav"
iNumberOfFiles lenarray SFilenames
iFile random 0, iNumberOfFiles
iFile = round(iFile)
Sfile = SFilenames[iFile]
; Lese einen Soundfile mit einem Phasor aus einem Table aus
iNchnls filenchnls Sfile
if iNchnls == 1 goto monoFile
				goto stereoFile
monoFile:
iloopTableL ftgen 0, 0, 0, 1, Sfile, 0, 0, 1 
iloopTableR = iloopTableL
;MkSpeed init p4
aIndex phasor (sr/ftlen(iloopTableL))*kSpeed
aloopL table3 aIndex, iloopTableL, 1
aloopR = aloopL
aloopR delay aloopR, 0.008 
				goto weiter
stereoFile:
iloopTableL ftgen 0, 0, 0, 1, Sfile, 0, 0, 1 
iloopTableR ftgen 0, 0, 0, 1, Sfile, 0, 0, 2 
;kSpeed init p4
aIndex phasor (sr/ftlen(iloopTableL))*kSpeed
aloopL table3 aIndex, iloopTableL, 1
aloopR table3 aIndex, iloopTableR, 1
weiter: 
; Set new playbackspeed after the soundfile played once
kCurrentPhs = k(aIndex)
kPreviousPhase init 0
if k(aIndex) < kPreviousPhase then
	kSpeed random giLowestLoopSpeed, giMaxLoopSpeed
endif
kPreviousPhase = k(aIndex)
; Lowspass Filter
kCF scale p5, 1600, 80, -12, -24;, 1, 0.1
aloopL butterlp aloopL, kCF
aloopR butterlp aloopR, kCF
; Panning
aPanLFO oscil 1, p6
aPanLFO = (aPanLFO+1)*0.5
aSigL1, aSigR1 pan2 aloopL, aPanLFO
aSigL2, aSigR2 pan2 aloopR, aPanLFO
aSigL sum aSigL1, aSigL2
aSigR sum aSigR1, aSigR2
; Output
kAmpReduction scale2 kSpeed, 1, .25, giMaxLoopSpeed, giLowestLoopSpeed  
kAmpReduction port kAmpReduction, 0.25
aEnv linseg 0, 0.05, 1, p3 - 0.1, 1, 0.05, 0
aOutL = ((aSigL * aEnv) * kAmpReduction)* ampdbfs(p5)
aOutR = ((aSigR * aEnv) * kAmpReduction)* ampdbfs(p5)
outs aOutL, aOutR
;send to reverb
kReverbSendAmount scale2 kSpeed, -6, -3, giMaxLoopSpeed, giLowestLoopSpeed
kReverbSendAmount port kReverbSendAmount, 0.25
ksend = ampdbfs(kReverbSendAmount)
garev1=+ aOutL*ksend
garev2=+ aOutR*ksend
endin

instr 2 ; Paul-Stretch Background Ambient
; Lese einen Ordner auf .wav aus
iCount init 0
SFilenames[] directory gSdir, ".wav"
iNumberOfFiles lenarray SFilenames
iFile random 0, iNumberOfFiles
iFile = round(iFile)
Sfile = SFilenames[iFile]
;;; Paul-Stretch
istretchFact = 50 										; Stretch Faktor
iwindowSize = .1 										; Window Size
giSmp1 ftgen 0, 0, 0, 1, Sfile, 0.5, 0, 1
giSmp2 ftgen 0, 0, 0, 1, Sfile, 0.5, 0, 1
aStretchLeft paulstretch istretchFact, iwindowSize, giSmp1
aStretchRight paulstretch istretchFact, iwindowSize, giSmp2
; Lowpass Filter
aRMSIn sum aStretchLeft, aStretchRight
kRMS rms aRMSIn 
;printk 0.125, kRMS
kCF port kRMS, 0.5
kCF scale kCF, 80, 1600, 0.2, 0.
aStretchLeftLP butterlp aStretchLeft, kCF
aStretchRightLP butterlp aStretchRight, kCF
; Output
aEnv linseg 0, 0.05, 1, p3 - 0.1, 1, 0.05, 0
aOutL = (aStretchLeftLP * aEnv)* ampdbfs(-6)
aOutR = (aStretchRightLP * aEnv)* ampdbfs(-6)
outs aOutL, aOutR
endin

instr 999;reverb
ain1 = garev1
ain2 = garev2
kfblvl = .85
kfco = sr/6

arev1, arev2 reverbsc ain1, ain2, kfblvl, kfco

outs arev1, arev2

clear garev1, garev2
endin
;---------------------------------------------------
</CsInstruments>
<CsScore>
i111 0 60
i1 0 60
i2 0 60
i999 0 80
</CsScore>
</CsoundSynthesizer>