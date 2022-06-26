;	EAU
;	GEN08 — Generate a piecewise cubic spline curve.
;	y + x

gieau_y1		init 0
gieau_x1		init gienvdur/4

gieau_y2		init .125
gieau_x2		init gieau_x1+gienvdur/4

gieau_y3		init 1
gieau_x3		init gieau_x2+gienvdur/4

gieau_y4		init 0
gieau_x4		init gieau_x3+gienvdur/4


;-----------------------
gieau		ftgen	0, 0, gienvdur, 8,	\
			gieau_y1, gieau_x1, 	\
			gieau_y2, gieau_x2,	\
			gieau_y3, gieau_x3,	\
			gieau_y4, gieau_x4	\

;-----------------------
