;	ISOTRAP
;	an isosceles trapezoid
gisotrap_ramp		init sr * 15$ms
gisotrap_seg		init gienvdur-(gisotrap_ramp*2)
;-----------------------
gisotrap		ftgen	0, 0, gienvdur, 7, 0, gisotrap_ramp, 1, gisotrap_seg, 1, gisotrap_ramp, 0
;-----------------------
