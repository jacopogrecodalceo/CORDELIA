gSflower_path init "/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/samp-flower"

	$start_instr(flower)

iclock_sec 	rtclock
inum        init 1 + floor(iclock_sec % 419)
Snum    		sprintf "%d", inum
while strlen(Snum) < 4 do
    Snum strcat "0", Snum
od
Spath       sprintf "/Users/j/Desktop/perc/colored/flower_coloured-%s.wav", Snum
ilen        filelen Spath
ift			ftgenonce 0, 0, 0, 1, Spath, 0, 0, 0

aout			table3 phasor(1/idur+random:i(-.005, .005)), ift, 1
aout			*= idyn

	$dur_var(10)
	$end_instr

