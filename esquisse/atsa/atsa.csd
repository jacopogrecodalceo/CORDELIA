<CsoundSynthesizer>
<CsOptions>
-odac
</CsOptions>
<CsInstruments>

sr = 48000
ksmps = 32
nchnls = 2
0dbfs = 1

gioscildur init 8192

gisaw			ftgen	0, 0, gioscildur, 7, 1, gioscildur, -1				; sawtooth wave, downward slope

	instr 1

iamp		init 1
ifreq		init p4
iatsfile	init p5
ich			init p6

idur		ATSinfo iatsfile, 7
;p3			init idur
imax_par 	ATSinfo iatsfile, 3
ipar		int random:i(1, imax_par)

ktime 		line 0, p3, idur

kfreq, kamp ATSread ktime, iatsfile, ipar

aamp        a  kamp
afreq       a  kfreq*ifreq

i1div2pi		init 1/24

kpeakdev		= aamp * 2 * i1div2pi
kpeakdev2		= aamp * cosseg(3, idur, 5) * i1div2pi

;STEREO "CHORUS" ENRICHMENT USING JITTER
kjitR			jitter cosseg(5, idur, .75), 1.5, 3.5

;MODULATORS
aModulator		oscili	kpeakdev*linseg(0, idur, 1), afreq * 5
aModulator2		oscili	kpeakdev2*cosseg(0, idur, 1), afreq * 2, gisaw

avib1			= lfo(kfreq/32, kfreq/250)*abs(jitter(1, 1/p3, 100/p3))

aCarrierR		phasor	portk(kfreq + kjitR, idur/96, 20)+avib1
aCarrierR		table3	aCarrierR + aModulator + aModulator2, gisaw, 1, 0, 1
aSigR			= aCarrierR * aamp

aFilterR		bqrez	aSigR, afreq+(afreq*(16*aamp)), .75
aout			balance2 aFilterR, aSigR

		outch ich, aout

	endin

	instr 2

indx init 0
;i1 0 {dur} {freq} "{file_ats}" {ch+1}
until indx > 75 do
	schedule 1, 0, 90, 1, "/Users/j/Documents/PROJECTs/CORDELIA/esquisse/atsa/alina-glued-1ch.ats", (indx%2)+1
	indx += 1
od
turnoff

	endin

</CsInstruments>
<CsScore>
; sine wave table
f 1 0 16384 10 1
i 2 0 1
e
</CsScore>
</CsoundSynthesizer>
