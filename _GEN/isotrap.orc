;	ISOTRAP
;	an isosceles trapezoid
giisotrap_ramp		init sr * .015
giisotrap_seg		init gienvdur-(giisotrap_ramp*2)
;-----------------------
giisotrap		ftgen	0, 0, gienvdur, 7, 0, giisotrap_ramp, 1, giisotrap_seg, 1, giisotrap_ramp, 0
;-----------------------
