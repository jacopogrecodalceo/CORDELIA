ginere	hc_gen 0, gienvdur, 0, \ 
		hc_segment(3/110, 0.67085, hc_gaussian_curve(0.01376, 2.58338)), \ 
		hc_segment(7/110, 0.17233, hc_toxoid_curve(1.92698)), \ 
		hc_segment(63/110, 1, hc_tightrope_walker_curve(0.53033, 0.36436)), \ 
		hc_segment(30/110, 0, hc_tightrope_walker_curve(0.98301, 0.72846))