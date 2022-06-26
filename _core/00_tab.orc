;		ftgen	ifn, itime, isize, igen, iarga


;	OSCIL GEN
gisine		ftgen	0, 0, gioscildur, 10, 1					; sine wave
gisquare	ftgen	0, 0, gioscildur, 7, 1, gioscildur/2, 1, 0, -1, gioscildur/2, -1		; square wave 
gitri		ftgen	0, 0, gioscildur, 7, 0, gioscildur/4, 1, gioscildur/2, -1, gioscildur/4, 0		; triangle wave 
gisaw		ftgen	0, 0, gioscildur, 7, 1, gioscildur, -1				; sawtooth wave, downward slope

;	TIME GEN
girall		ftgen	0, 0, 16384, 5, giexpzero, 14500, .15, 1500, 1, 385, 1
giacc		ftgen	0, 0, 16384, 5, 1, 1500, .15, 1, 14500, giexpzero
gilinear	ftgen	0, 0, 16384, 7, 0, 16384, 1

/*
;	LFOs GEN
gilowsine	ftgen	0, 0, gienvdur, 10, 1				; sine wave
gilowsquare	ftgen	0, 0, gienvdur, 7, 1, gienvdur/2, 1, 0, -1, gienvdur/2, -1	; square wave 
gilowtri	ftgen	0, 0, gienvdur, 7, 0, gienvdur/4, 1, gienvdur/2, -1, gienvdur/4, 0	; triangle wave 
gilowsaw	ftgen	0, 0, gienvdur, 7, 1, gienvdur, -1			; sawtooth wave, downward slope
*/

;					pna, stra, phsa, dcoa

gihsine	ftgen	0, 0, gienvdur, 9, .5, 1, 0
gihsquare	ftgen	0, 0, gienvdur, 7, 1, gienvdur/2, 1, 0, 0, gienvdur/2		; square wave 
gihtri	ftgen	0, 0, gienvdur, 7, 0, gienvdur/2, 1, gienvdur/2, 0		; triangle wave 
gihsaw	ftgen	0, 0, gienvdur, 7, 1, gienvdur, 0			; sawtooth wave, downward slope

gilowasine	init gihsine
gilowasquare	init gihsquare
gilowatri	init gihtri
gilowasaw	init gihsaw

;		MORE
gioddharm	ftgen	0, 0, gioscildur, 13, 1, 2, 0, 3, 2, 0, 9, .333, 180

gihan		ftgen   0, 0, gienvdur, 20, 2
;		WAVESHAPING
gisigm1		ftgen	0, 0, 257, 9, .5, 1, 270
gisigm2		ftgen	0, 0, 257, 9, .5, 1, 270, 1.5, .35, 90, 2.5, .215, 270, 3.5, .145, 90, 4.5, .115, 270
