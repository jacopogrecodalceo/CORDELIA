prints "\n---BITE---\n"
;	a 3-points function from segments of exponential curves

ibite_intatk1	init 11
ibite_intdec1	init 9
ibite_sus1	init .65
ibite_intrel1	init 3

ibite_int1		init ibite_intatk1 + ibite_intdec1 + ibite_intrel1

ibite_atk1  	init ibite_intatk1 / ibite_int1
ibite_dec1  	init ibite_intdec1 / ibite_int1
ibite_rel1		init ibite_intrel1 / ibite_int1

ibite_dur1		init gienvdur/2


ibite_intatk2	init 15
ibite_intdec2	init 5
ibite_sus2	init .45
ibite_intrel2	init 9

ibite_int2		init ibite_intatk2 + ibite_intdec2 + ibite_intrel2

ibite_atk2  	init ibite_intatk2 / ibite_int2
ibite_dec2  	init ibite_intdec2 / ibite_int2
ibite_rel2		init ibite_intrel2 / ibite_int2

ibite_dur2		init gienvdur/2
;-----------------------
gibite		ftgen	0, 0, gienvdur, 5, giexpzero, ibite_atk1*ibite_dur1, 1, ibite_dec1*ibite_dur1, ibite_sus1, ibite_rel1*ibite_dur1, giexpzero, ibite_atk2*ibite_dur1, .75, ibite_dec2*ibite_dur1, ibite_sus2, ibite_rel2*ibite_dur1, giexpzero
;-----------------------
