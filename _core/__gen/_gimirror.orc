;	MIRROR
;	a palindrome 3(6)-points function from linear segments
gimirror_int		init 9
;-----------------------
gimirror_intatk		init .5
gimirror_intdec		init 1
gimirror_intrel		init 3
;-----------------------
gimirror_atk		init gimirror_intatk / gimirror_int
gimirror_dec		init gimirror_intdec / gimirror_int
gimirror_sus		init .35
gimirror_rel		init gimirror_intrel / gimirror_int
;-----------------------
gimirror		ftgen	0, 0, gienvdur, 7, 0, gienvdur*gimirror_atk, 1, gienvdur*gimirror_dec, gimirror_sus, gienvdur*gimirror_rel, 0, gienvdur*gimirror_rel, gimirror_sus, gienvdur*gimirror_dec, 1, gienvdur*gimirror_atk, 0
;-----------------------
