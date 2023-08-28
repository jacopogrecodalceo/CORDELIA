;sr		=	192000
sr		=	48000

ksmps		=	64	;leave it at 64 for real-time
;nchnls_i	=	2
nchnls		=	2
0dbfs		=	1
;A4		=	438	;only for ancient music	

ginchnls	init nchnls		;e.g. click track
gioffch		init 0		;e.g. I want to go out in 3, 4

gimainclock_ch init 5
giquarterclock_ch init 6

gisend_freq1_ch	init 7 
gisend_freq2_ch	init 8

gieva_memories init 0
;#define hydraudiosync ##
;#define printscore ##
;#define midi  ##
;#define diskclavier  ##
;#define royaumont ##

