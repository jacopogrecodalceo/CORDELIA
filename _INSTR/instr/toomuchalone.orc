maxalloc "toomuchalone", nchnls

gktoomuchalone_dur		init 1

gitoomuchalone_morf		ftgen 0, 0, 3, -2, gisaw, gitri, gisquare
gitoomuchalone_dummy	ftgen 0, 0, gioscildur, 10, 1

gktoomuchalone_env		init 0

	instr toomuchalone

gktoomuchalone_dur		= p3
gktoomuchalone_amp		= p4
gktoomuchalone_cps		= p6

ich						init p7

kph						portk abs(active:k("toomuchalone")), gktoomuchalone_dur
gktoomuchalone_env		table3 kph, int(abs(p5)), 1

	

	instr toomuchalone_instr

Sinstr		init "toomuchalone"
ich			init p4

kport_amp	= gktoomuchalone_dur/8
kport_cps	= gktoomuchalone_dur/4
;kport_env	= gktoomuchalone_dur/4

kdyn		= portk(gktoomuchalone_amp, kport_amp)
kcps		= portk(gktoomuchalone_cps, kport_cps)

kranfreq	= kdyn/(gktoomuchalone_dur*8) ;.05

acar		oscil3 1, (kcps/2)+oscil3(kcps/100, kcps/randomi:k(95, 105, kranfreq, 3), gisine), gisine

kmorf		table3	phasor:k(kdyn/gktoomuchalone_dur), gieclassicr, 1

			ftmorf(kmorf, gitoomuchalone_morf, gitoomuchalone_dummy)

kmod		= kcps/randomi:k(35, 45, .05, 3)
kndx		= randomi:k(.25, .5, .05, 3)

ai			foscil kdyn, kcps+oscil3:k(kcps/100, kcps/randomi:k(95, 105, kranfreq, 3), gisine), acar, kmod, kndx, gitoomuchalone_dummy

kcf			table3	phasor:k(kdyn/gktoomuchalone_dur), giclassic, 1
kres		= .95 * table3(phasor:k(kdyn/gktoomuchalone_dur), gifade, 1)

af			moogladder2 ai, (kcps/2)+(kcps*(kcf*randomi:k(16, 24, kranfreq, 3))), kres

;kenv		portk limit(abs(active:k("toomuchalone")), 0, 1), kport_env

kenv		portk abs(active:k("toomuchalone")), 35$ms

gktoomuchalone_env	*= kenv

aout		= af+ai

aout		*= gktoomuchalone_env

aout		buthp aout, 21.5

	$CHNMIX

	

indx	init 0
until	indx == nchnls do
	schedule nstrnum("toomuchalone_instr")+(indx/1000), 0, -1, indx+1
	indx	+= 1
od
