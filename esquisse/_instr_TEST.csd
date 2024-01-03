<CsoundSynthesizer>

<CsOptions>
-odac0
--sample-rate=48000
</CsOptions>

<CsInstruments>

nchnls = 2
ksmps = 16
0dbfs = 1

#include "./csound_cordelia/1-character/1-MACRO.orc"
#include "./csound_cordelia/1-character/2-GLOBAL_VAR.orc"
#include "./csound_cordelia/1-character/3-FORMAT.orc"
#include "./csound_cordelia/2-head/GEN/1-polar/asaw.orc"
#include "./csound_cordelia/2-head/GEN/1-polar/asine.orc"
#include "./csound_cordelia/2-head/GEN/1-polar/asquare.orc"
#include "./csound_cordelia/2-head/GEN/1-polar/atri.orc"
#include "./csound_cordelia/2-head/GEN/2-bipolar/saw.orc"
#include "./csound_cordelia/2-head/GEN/2-bipolar/sine.orc"
#include "./csound_cordelia/2-head/GEN/2-bipolar/square.orc"
#include "./csound_cordelia/2-head/GEN/2-bipolar/tri.orc"
#include "./csound_cordelia/2-head/GEN/3-window/hamming.orc"
#include "./csound_cordelia/2-head/GEN/3-window/hanning.orc"
#include "./csound_cordelia/2-head/SPACE.orc"
#include "./csound_cordelia/3-body/1-ORGAN.orc"
#include "./csound_cordelia/3-body/2-OP/basic/approx.orc"
#include "./csound_cordelia/3-body/2-OP/basic/each.orc"
#include "./csound_cordelia/3-body/2-OP/basic/envgen.orc"
#include "./csound_cordelia/3-body/2-OP/basic/envgenk.orc"
#include "./csound_cordelia/3-body/2-OP/basic/eva.orc"
#include "./csound_cordelia/3-body/2-OP/basic/eva_midi.orc"
#include "./csound_cordelia/3-body/2-OP/basic/eva_sonvs.orc"
#include "./csound_cordelia/3-body/2-OP/basic/getmeout.orc"
#include "./csound_cordelia/3-body/2-OP/basic/start.orc"
#include "./csound_cordelia/3-body/2-OP/basic/turnoff_everything.orc"
#include "./csound_cordelia/3-body/2-OP/freq/cedonoi.orc"
#include "./csound_cordelia/3-body/2-OP/freq/cpstun_render.orc"
#include "./csound_cordelia/3-body/2-OP/freq/edo.orc"
#include "./csound_cordelia/3-body/2-OP/freq/fc.orc"
#include "./csound_cordelia/3-body/2-OP/freq/fc3.orc"
#include "./csound_cordelia/3-body/2-OP/freq/fch.orc"
#include "./csound_cordelia/3-body/2-OP/freq/misha.orc"
#include "./csound_cordelia/3-body/2-OP/freq/step.orc"
#include "./csound_cordelia/3-body/2-OP/freq/stepc.orc"
#include "./csound_cordelia/3-body/2-OP/rhythm/eu.orc"
#include "./csound_cordelia/3-body/2-OP/rhythm/hex.orc"
#include "./csound_cordelia/3-body/2-OP/rhythm/jex.orc"
#include "./csound_cordelia/3-body/2-OP/rhythm/saf.orc"
#include "./csound_cordelia/3-body/2-OP/util/accent.orc"
#include "./csound_cordelia/3-body/2-OP/util/accenth.orc"
#include "./csound_cordelia/3-body/2-OP/util/almost.orc"
#include "./csound_cordelia/3-body/2-OP/util/come_in_q.orc"
#include "./csound_cordelia/3-body/2-OP/util/come_in_s.orc"
#include "./csound_cordelia/3-body/2-OP/util/dec_to_int.orc"
#include "./csound_cordelia/3-body/2-OP/util/exist_in_q.orc"
#include "./csound_cordelia/3-body/2-OP/util/lfh.orc"
#include "./csound_cordelia/3-body/2-OP/util/metrout.orc"
#include "./csound_cordelia/3-body/2-OP/util/morpheus.orc"
#include "./csound_cordelia/3-body/2-OP/util/once.orc"
#include "./csound_cordelia/3-body/2-OP/util/oncegen.orc"
#include "./csound_cordelia/3-body/2-OP/util/one.orc"
#include "./csound_cordelia/3-body/2-OP/util/op_circles.orc"
#include "./csound_cordelia/3-body/2-OP/util/op_compression.orc"
#include "./csound_cordelia/3-body/2-OP/util/op_externals.orc"
#include "./csound_cordelia/3-body/2-OP/util/op_modulator.orc"
#include "./csound_cordelia/3-body/2-OP/util/op_ramp.orc"
#include "./csound_cordelia/3-body/2-OP/util/pump.orc"
#include "./csound_cordelia/3-body/2-OP/util/rprtab.orc"
#include "./csound_cordelia/3-body/2-OP/util/schedulech.orc"
#include "./csound_cordelia/3-body/2-OP/util/tabj.orc"
#include "./csound_cordelia/3-body/3-SOUL.orc"
#include "./csound_cordelia/3-body/4-ADDONs.orc"

	$start_instr(hihi)

; ============
; METALLIC NOISE
; ============
kbcL init 1 ; Boundary condition at left end of bar (1 is clamped, 2 pivoting and 3 free).
kbcR init 3 ; Boundary condition at right end of bar (1 is clamped, 2 pivoting and 3 free).

iK init 3 ; dimensionless stiffness parameter. If this parameter is negative then the initialisation is skipped and the previous state of the bar is continued.
ib init 0.00125 ; high-frequency loss parameter (keep this small).

kscan cosseg .235, idur, .5 ; Speed of scanning the output location.

iT30 init 5; 30 db decay time in seconds.

ipos random .895, .95; position along the bar that the strike occurs.
ivel init idyn$k; normalized strike velocity.
iwid init .5; spatial width of strike.

anoi barmodel kbcL, kbcR, iK, ib, kscan, iT30, ipos, ivel, iwid

; ============
; RESONANT BANDPASS
; ============
kfreq init 3.5$k
kq init .85
kdrive init .125
a_, a_, abp, a_ svn anoi, kfreq, kq, kdrive

; ============
; DISTORTION
; ============
#define hihi_jit #jitter(1, ibeatf/12, ibeatf/8)#
acheb chebyshevpoly abp, 0, $hihi_jit, $hihi_jit, $hihi_jit, $hihi_jit, $hihi_jit, $hihi_jit, $hihi_jit

; ============
; ENVELOPE
; ============
	$dur_var(10)
	$env_gen

; ============
; HIGHPASS
; ============
kfreq init 7.5$k
kq init .85
kdrive init .125
aout, a_, a_, a_ svn acheb, kfreq, kq, kdrive

	$channel_mix
	endin

schedule "hihi", 0, 1, 1, $p, giclassic, 400

</CsInstruments>
<CsScore>
f0 z
</CsScore>
</CsoundSynthesizer>
