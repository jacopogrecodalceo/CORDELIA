;	SPINA
;	GEN08 — Generate a piecewise cubic spline curve.

gispina_y1		init 0
gispina_x1		init gienvdur/4

gispina_y2		init .125
gispina_x2		init gispina_x1+gienvdur/4

;-----------------------
gispina			ftgen	0, 0, gienvdur, 5, giexpzero, gienvdur/2, 1, gienvdur/2, giexpzero
;-----------------------
