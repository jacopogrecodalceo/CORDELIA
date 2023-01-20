#ifdef MIDIin

	instr statusMIDI

kstatus, kchan, knote, kvel midiin

Sinstr	init "bebois"
iwhen	init 0
idur	init 3
kamp	= kvel/512
ienv	init giclassic
kcps	= knote

kgate	init 0

if kstatus == 144 && kvel > 0 && kgate == 0 then
	schedulek "sendMIDI", 0, 0, Sinstr, iwhen, idur, kamp, ienv, kcps
	kgate = 1
endif

if kgate == 1 then
	kgate trighold kgate, .25
endif

	endin
	alwayson("statusMIDI")

;---|---|---

	instr sendMIDI

Sinstr	init p4
iwhen	init p5
idur	init p6
iamp	init p7
ienv	init p8
inote	init p9
icps	cpstuni inote, i(gktuning)

	evaMIDI Sinstr, iwhen, idur, iamp, ienv, icps
	prints "midi---%s, %.02f, %.02f, %.02f, %.02f, %.02f, %.02f\n", Sinstr, iwhen, idur, iamp, ienv, icps

	endin

#end
