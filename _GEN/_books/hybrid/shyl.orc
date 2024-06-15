gishyl	hc_gen 0, gienvdur, 0, \ 
		hc_segment(2/27, 1, hc_power_curve(0.96695)), \ 
		hc_segment(1/27, 0.60273, hc_hamming_curve()), \ 
		hc_segment(1/27, 0.20616, hc_toxoid_curve(1.55173)), \ 
		hc_segment(1/27, 0.89778, hc_gaussian_curve(0.91533, 0.5554)), \ 
		hc_segment(1/27, 0.95094, hc_blackman_curve()), \ 
		hc_segment(1/27, 0.17297, hc_blackman_curve()), \ 
		hc_segment(13/27, 0.36221, hc_blackman_curve()), \ 
		hc_segment(1/27, 0.60394, hc_power_curve(0.55262)), \ 
		hc_segment(6/27, 0, hc_cubic_curve())