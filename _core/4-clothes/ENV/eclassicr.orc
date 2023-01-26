gieclassic_atk		init sr * 5$ms
gieclassic_dur		init gienvdur - gieclassic_atk
gieclassic_int		init 9
gieclassic_intdec	init 5
gieclassic_dec		init gieclassic_intdec / gieclassic_int
gieclassic_sus		init .15
gieclassic_intrel	init gieclassic_int-gieclassic_intdec
gieclassic_rel		init gieclassic_intrel / gieclassic_int
gieclassicr		ftgen	0, 0, gienvdur, 5, giexpzero, gieclassic_dur*gieclassic_rel, gieclassic_sus, gieclassic_dur*gieclassic_dec, 1, gieclassic_atk, giexpzero
