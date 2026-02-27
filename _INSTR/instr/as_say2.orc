
gSas_say2_path init "/Users/j/Desktop/360210-asylum-say_I_say"
gias_say2_n init 83
gSas_say2_fix init "electronic_music"

    $start_instr(as_say2)

inum        init 1 + floor(icps % gias_say2_n)
; pad to 4 digits
Snum    sprintf "%d", inum
while strlen(Snum) < 4 do
    Snum strcat "0", Snum
od

Spath       sprintf "%s/%s-%s.wav", gSas_say2_path, gSas_say2_fix, Snum

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


