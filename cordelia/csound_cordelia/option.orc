--sample-rate=48000
--ksmps=64	;leave it at 64 for real-time
;--nchnls_i=2
--nchnls=2
--0dbfs=1
;A4		=	438	; only for ancient music	

;--port=10000
;--format=float
-3

;-D
;MIDI is HERE
-Ma
;-M0
;-+msg_color=1
;--messagelevel=99

--m-amps=1
--m-range=1
--m-warnings=0
--m-dB=1
--m-colours=1
--m-benchmarks=0
;-m0d ; Remove all messages
-+id_artist="jacopo greco d'alceo"

;suggested https://csound-floss-dev.firebaseapp.com/how-to/hardware#realtime-audio-issues-and-errors
;-b 16284
;-B 16284

;--realtime
-+rtaudio=pa_cb
;-+rtaudio=PortAudio
;-+rtaudio=jack
;-+rtaudio=CoreAudio

;-+rtaudio=auhal


;--num-threads=10
;--udp-echo

;--nosound

;-v		;verbose orch translation
;-N		;notify (ring the bell) when score or miditrack is done
;--postscriptdisplay     ;suppress graphics, use Postscript displays
