gizero			init ksmps / sr		;i variable better than write zero? because it's between samples
gkzero			init ksmps / sr		;k variable better than write zero? because it's between samples


giexpzero		init .00015		;a zero value for expseg

giadjust	init 1-(gizero*ksmps)

gkgain			init 2/3			;master gain for "mouth" instrument

gkabstime		init 0

giminnote		init 50$ms

gimaxnote		init 300;s

;			2 types of envelopes : envelope (0, 1), oscil(-1, 1)
gienvdur		init 8192		;duration for all envelopes gen envelope tables
gioscildur		init 16384		;duration for all envelopes gen envelope tables

gkdyn			init 1

gkclearchns[]		init 128

gis_midi		init 0

gixtratim		init 15

;----------------------------------------
;			REAPER		|
;----------------------------------------

gkrpr1			init 0
gkrpr2			init 0
gkrpr3			init 0
gkrpr4			init 0

gkrpr_arr1		init 16
gkrpr_arr2		init 16
gkrpr_arr3		init 16
gkrpr_arr4		init 16
					
gSrpr1			init 0
gSrpr2			init 0
gSrpr3			init 0
gSrpr4			init 0

;----------------------------------------
;			OSC		|
;----------------------------------------
gShost			init "localhost"
giport			init 10005
giruby_port		init 10015

