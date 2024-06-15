;	KAZAN
;	a 3-points function from segments of exponential curves
gikazan_int		init 11
gikazan_intatk		init 1
gikazan_intdec		init 9
gikazan_intrel		init gikazan_int-gikazan_intatk-gikazan_intdec
;-----------------------
gikazan_atk		init gikazan_intatk / gikazan_int
gikazan_dec		init gikazan_intdec / gikazan_int
gikazan_sus		init .35
gikazan_rel		init gikazan_intrel / gikazan_int
;-----------------------
print gikazan_atk
print gikazan_dec
print gikazan_sus
print gikazan_rel
;-----------------------
gikazan			ftgen	0, 0, gienvdur, 5, giexpzero, gienvdur*gikazan_atk, 1, gienvdur*gikazan_dec, gikazan_sus, gienvdur*gikazan_rel, giexpzero
;-----------------------
