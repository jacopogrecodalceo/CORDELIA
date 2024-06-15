;	LIKEAREV
;	a 6-points function from linear segments
gilikearev_atk		init sr * .005
gilikearev_dur		init gienvdur - gilikearev_atk
gilikearev_int		init 32
gilikearev_intdec		init 1
gilikearev_dec		init gilikearev_intdec / gilikearev_int

gilikearev_sus1		init .15
gilikearev_intrel1		init 3
gilikearev_rel1		init gilikearev_intrel1 / gilikearev_int

gilikearev_sus2		init .05
gilikearev_intrel2		init gilikearev_int-gilikearev_intdec-gilikearev_intrel1
gilikearev_rel2		init gilikearev_intrel2 / gilikearev_int

;-----------------------
gilikearev		ftgen	0, 0, gienvdur, 7, 0, gilikearev_atk, 1, gilikearev_dur*gilikearev_dec, gilikearev_sus1, gilikearev_dur*gilikearev_rel1, gilikearev_sus2, gilikearev_dur*gilikearev_rel2, 0
;-----------------------
