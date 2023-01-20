;	EMIRROR
;	a palindrome 3(6)-points function from linear segments
giemirror_int		init 9
;-----------------------
giemirror_intatk	init .5
giemirror_intdec	init 1
giemirror_intrel	init 3
;-----------------------
giemirror_atk		init giemirror_intatk / giemirror_int
giemirror_dec		init giemirror_intdec / giemirror_int
giemirror_sus		init .35
giemirror_rel		init giemirror_intrel / giemirror_int
;-----------------------
giemirror		ftgen	0, 0, gienvdur, 5, giexpzero, gienvdur*giemirror_atk, 1, gienvdur*giemirror_dec, giemirror_sus, gienvdur*giemirror_rel, giexpzero, gienvdur*giemirror_rel, giemirror_sus, gienvdur*giemirror_dec, 1, gienvdur*giemirror_atk, giexpzero
;-----------------------
