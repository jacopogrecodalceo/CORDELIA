<CsoundSynthesizer>
<CsOptions>
--port=10000
--format=float
-m0
-D
;-+msg_color=1
--messagelevel=96
--m-amps=1

;-b 128 ; 1024
;-B 256 ; 4096

;-+rtaudio=CoreAudio
;-+rtaudio=auhal

;--realtime
;--num-threads=4
;--m-colours=1
;--udp-echo

;--midioutfile=FILENAME
;--nosound

;-v		;verbose orch translation
;-N		;notify (ring the bell) when score or miditrack is done
;--postscriptdisplay     ;suppress graphics, use Postscript displays
--env:SSDIR=/Users/j/Documents/PROJECTs/IDRA/samples ;/Users/j/Documents/my_livecode/_samples
;--env:OPCODE6DIR64=/Library/Frameworks/CsoundLib64.framework/Versions/6.0/Resources/Opcodes64
</CsOptions>
<CsInstruments>

sr		=	192000	
ksmps		=	64	;leave it at 64 for real-time
nchnls_i	=	12
nchnls		=	2
0dbfs		=	1
;A4		=	438	;only for ancient music	

ginchnls	init nchnls	;e.g. click track
gioffch		init 0		;e.g. I want to go out in 3, 4

;		INs
ginkick_ch	init 9	;a mono channel
ginsna_ch	init 10

;#define hydraudiosync ##
;#define printscore ##
;#define midi  ##
;#define diskclavier  ##




#include "/Users/j/Documents/PROJECTs/CORDELIA/_core/_livecode-include.csd"
