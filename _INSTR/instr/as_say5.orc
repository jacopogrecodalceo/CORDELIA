
gSas_say5_path init "/Users/j/Desktop/360210-asylum-say_I_say"
gias_say5_n init 79
gSas_say5_fix init "heartbeat"

    $start_instr(as_say5)

inum        init 1 + floor(icps % gias_say5_n)
; pad to 4 digits
Snum    sprintf "%d", inum
while strlen(Snum) < 4 do
    Snum strcat "0", Snum
od

Spath       sprintf "%s/%s-%s.wav", gSas_say5_path, gSas_say5_fix, Snum

ilen        filelen Spath
if p3 > ilen then
    p3          init ilen
endif
idur            init p3

aenv            linseg 0, .005, 1, idur-.005-.05, 1, .05, 0
aout 		    diskin Spath, 1+random(-.05, .05)
aout            *= idyn
aout            *= aenv
;aout            diode_ladder aout, limit(5500+(idyn*11000), 20, 19000), 13

	$channel_mix
	endin


