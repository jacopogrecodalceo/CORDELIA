
	instr init_sco

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

	endin

	instr render_csv_noteon

isec		elapsedtime
ibpm		init 60
istart		init (isec*1000 / ibpm * 192)
ichannel	init 1
inote		init p4
ivel		init 95
;2, 0, Note_on_c, 1, 79, 81

kdone		system 1, sprintfk("echo \'2, %i, Note_on_c, %i, %i, %i\' >> %s", istart, ichannel, inote, ivel, $CSV_NAME)
			schedule "render_csv_noteoff", p3, 1, inote
			turnoff

	endin



	instr render_csv_noteoff

isec		elapsedtime
ibpm		init 60
istart		init (isec*1000 / ibpm * 192)
ichannel	init 1
inote		init p4
ivel		init 0
;2, 0, Note_on_c, 1, 79, 81

kdone		system 1, sprintfk("echo \'2, %i, Note_off_c, %i, %i, %i\' >> %s", istart, ichannel, inote, ivel, $CSV_NAME)
;kdone		system 1, sprintfk("echo \'2, %i, Note_off_c, %i, %i, %i\' >> %s", istart+1600, ichannel, inote, 0, $CSV_NAME)
			turnoff

	endin
