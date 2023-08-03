<CsoundSynthesizer>
<CsOptions>
; Select audio/midi flags here according to platform
-odac  ;;;RT audio out 
-j8
;-iadc    ;;;uncomment -iadc for RT audio input is needed too
; For Non-realtime ouput leave only the line below:
; -o ATScross.wav -W ;;; for file output any platform
</CsOptions>
<CsInstruments>

sr		= 48000
ksmps	= 32
nchnls	= 2
0dbfs	= 1

; by Menno Knevel - 2023

;ATSA wants a mono file!
;it takes a while to analyze these files...
;ires1 system_i 1,{{ atsa /Users/j/Desktop/m1.wav /Users/j/Documents/PROJECTs/CORDELIA/esquisse/atsa/1.ats }} 
prints "\n***1st analyzed file is ready***\n\n"

;ires2 system_i 1,{{ atsa /Users/j/Desktop/m2.wav /Users/j/Documents/PROJECTs/CORDELIA/esquisse/atsa/2.ats }} 
prints "\n***2nd analyzed file is ready***\n\n"
seed 0
gisaw			ftgen	0, 0, 8192, 7, 1, 8192, -1				; sawtooth wave, downward slope
gitab			ftgen	0, 0, 0, 1, "/Users/j/Desktop/untitled.wav", 0, 0, 0

	instr 1

indx init 0
imax_par 	ATSinfo "/Users/j/Documents/PROJECTs/CORDELIA/esquisse/atsa/1.ats", 3

until indx > imax_par do
	if indx % 4 == 1 then
		schedule 2, 0, 10, 1, "/Users/j/Documents/PROJECTs/CORDELIA/esquisse/atsa/1.ats", (indx%2)+1, indx
		print indx
	endif
	indx += 1
od

	endin

instr 2

kstatus init 1024

iamp		init 1
ifreq		init p4
iatsfile	init p5
ich			init p6

p3 = filelen("/Users/j/Desktop/untitled.wav")

idur		ATSinfo iatsfile, 7
;p3			init idur
imax_par 	ATSinfo iatsfile, 3
ipar		int p7

ktime 		line 0, p3, idur

kfreq, kamp ATSread ktime, iatsfile, ipar

aamp        a  kamp
afreq       a  kfreq

aout 		oscili iamp*kamp, afreq*ifreq, 1
		outall aout/(active(1)+1)
;printk 1, kamp
if kamp > .015 && kstatus > 1024 then
	schedulek 3, 0, 3, kamp, kfreq
	kstatus = 0
endif

	kstatus += 1
		endin

    instr 3
;ares pluck p4, p5+jitter(1, .25, 1), p5, 0, 1
ares oscili p4/(linseg(1, p3/3, active(3)+1)), p5, 1
ares dcblock2 ares
    outall ares*linseg:a(0, .005, 1, p3-.005, 0)

    endin

	instr 4

aout diskin "/Users/j/Desktop/untitled.wav"
	;outall aout*.125

	endin

schedule 4, 0, filelen("/Users/j/Desktop/untitled.wav")
</CsInstruments>
<CsScore>
f0 z
; sine wave.
f 1 0 16384 10 1
;          start    end
i 1 0 0
e
</CsScore>
</CsoundSynthesizer>