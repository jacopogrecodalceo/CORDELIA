;--port=10000
;--format=float
-3
-m0
;-D
;MIDI is HERE
;-Ma
;-M0
;-+msg_color=1
;--messagelevel=99

--m-amps=1
--m-range=1
--m-warnings=0
--m-dB=1
--m-colours=1
--m-benchmarks=0

-+id_artist="jacopo greco d'alceo"
;-b 64 ;mac 1024
;-B 128 ;mac 2048

;-b 2048
;-B 4096

;suggested https://csound-floss-dev.firebaseapp.com/how-to/hardware#realtime-audio-issues-and-errors
;-b 256
;-B 1024

;-b 128
;-B 1024
;--realtime
-+rtaudio=pa_cb
;-+rtaudio=PortAudio
;-+rtaudio=jack
;-+rtaudio=CoreAudio

;-b 1024
;-B 4096
;-+rtaudio=auhal


;--num-threads=8
;--udp-echo

;--nosound

;-v		;verbose orch translation
;-N		;notify (ring the bell) when score or miditrack is done
;--postscriptdisplay     ;suppress graphics, use Postscript displays
