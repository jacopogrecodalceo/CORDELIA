; exploign nlfilt as i wanted to create a vocabulary of filter of csoun
; i found myself in time of trouble and i decided to make an instrument

ganlf_source init 0

	instr nlf_control
/*
this method because sometimes
the generating noise instrument bugs
in this way i assure constant fresh monitoring
*/
ktime		timeinsts
kactive		active "nlf_source"

if kactive < 1 then
	schedulek "nlf_source", 0, -1
endif

if ktime > 60 then
	schedulek "nlf_control", 0, -1
	turnoff2 "nlf_source", 0, 0
	turnoff
endif
	endin
	schedule "nlf_control", 0, -1

	instr nlf_source
ka          randomi 0, .45, 1+jitter(.5, 24, 1/24), 3
kb          randomi 0, .25, 1+jitter(.5, 24, 1/24), 3
kd          randomi .85, .75, 1+jitter(.5, 24, 1/24), 3
kC          randomi .1, .5, 1+jitter(.5, 24, 1/24), 3
kL          randomi 25, 2500, 1+jitter(.5, 24, 1/24), 3

;printks " a%.2f b%.2f d%.2f C%.2f L%.2f\n", 1/2, ka, kb, kd, kC, kL

aran					rand .35

af						nlfilt aran, ka, kb, kd, kC, kL

ivar			init .05
alpf			diode_ladder af, kL*(9.75+ivar+jitter(ivar, 1, 1/32)), 9, 1, 1.235+jitter(.25, 1, 1/32)
aclip			clip alpf, 2, .95
ganlf_source	= aclip

gkcomb_var		= 24+jitter(4, 1, 1/32)

	endin

	$start_instr(nlf)

acomb			comb ganlf_source, 1/gkcomb_var, 1/icps; [, iskip] [, insmps]
avco			vco2 1/48, icps/2
ain				sum acomb, avco

ain			clip ain/2, 2, .95
alpf		diode_ladder ain, 1500+2000*idyn, 4.5, 1, 1.235+jitter(.25, 1, 1/32)
asum		sum alpf, ain/32

aout		balance2 ain, a(1/2)*idyn;oscili(1, 300)
aout		clip aout, 2, .95

	$dur_var(10)
	$end_instr