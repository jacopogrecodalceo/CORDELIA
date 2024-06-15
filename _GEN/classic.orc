;	CLASSIC
;	a 3-points function from linear segments
giclassic_atk		init sr * .005
giclassic_dur		init gienvdur - giclassic_atk
giclassic_int		init 9
giclassic_intdec	init 4
giclassic_dec		init giclassic_intdec / giclassic_int
giclassic_sus		init .15
giclassic_intrel	init giclassic_int-giclassic_intdec
giclassic_rel		init giclassic_intrel / giclassic_int
;-----------------------
giclassic		ftgen	0, 0, gienvdur, 7, 0, giclassic_atk, 1, giclassic_dur*giclassic_dec, giclassic_sus, giclassic_dur*giclassic_rel, 0
;-----------------------


