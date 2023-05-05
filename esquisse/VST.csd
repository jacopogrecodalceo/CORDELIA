<CsoundSynthesizer>
<CsOptions>
; Credits: Adapted by Michael Gogins 
; from code by David Horowitz and Lian Cheung. 
; The "--displays" option is required in order for 
; the Pianoteq GUI to dispatch events and display properly.
-m3 --displays -odac
</CsOptions>
<CsInstruments>
sr     = 44100
ksmps  = 20
nchnls = 2
                ; Load the Pianoteq into memory.
gipianoteq      vstinit "/Library/Audio/Plug-Ins/VST/FabFilter Pro-Q 3.vst", 1
                
                ; Print information about the Pianoteq, such as parameter names and numbers.
                vstinfo         gipianoteq
                
                ; Open the Pianoteq's GUI.
                vstedit         gipianoteq



</CsInstruments>
<CsScore>
f 0 z
</CsScore>
</CsoundSynthesizer>
