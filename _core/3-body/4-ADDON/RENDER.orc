
/* 	instr init_sco

istart		elapsedtime

idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6

Sinstr		init p7

kdone		system 1, sprintfk("echo \';%s\' >> %s", $SCO_NAME, $SCO_NAME)
kdone		system 1, sprintfk("echo \';%s\t\t\t%s\t\t\t%s\t\t\t%s\t\t\t%s\t\t\t%s\' >> %s", "instr", "start", "dur", "amp", "env", "freq", $SCO_NAME)
			turnoff

	endin
	schedule "init_sco", 0, 1



	instr render_sco

istart		elapsedtime

idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6

Sinstr		init p7

kdone		system 1, sprintfk("echo \'%s\t\t\t%0.5f\t\t\t%0.5f\t\t\t%0.5f\t\t\t%i\t\t\t%0.5f\' >> %s", Sinstr, istart, idur, iamp, iftenv, icps, $SCO_NAME)
			turnoff

	endin */



	instr render_midi_on
ichan		init 1
inote		init p4
ivel		init 95

			midion 1, inote, ivel
			schedule "render_midi_off", gibeats/4, inote
			turnoff
	endin

	instr render_midi_off
ichan		init 1
inote		init p4
ivel		init 0

			midion 1, inote, ivel
			turnoff
	endin
