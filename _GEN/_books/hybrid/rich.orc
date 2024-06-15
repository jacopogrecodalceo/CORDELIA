girich	hc_gen 0, gienvdur, 0, \ 
		hc_segment(1/40, 0.19607, hc_blackman_curve()), \ 
		hc_segment(1/40, 0.65294, hc_kiss_curve()), \ 
		hc_segment(1/40, 0.29282, hc_toxoid_curve(2.6382)), \ 
		hc_segment(1/40, 0.15045, hc_hanning_curve()), \ 
		hc_segment(2/40, 0.77689, hc_gaussian_curve(0.44594, 0.57684)), \ 
		hc_segment(5/40, 0.30218, hc_cubic_curve()), \ 
		hc_segment(2/40, 0.25578, hc_hanning_curve()), \ 
		hc_segment(1/40, 1, hc_toxoid_curve(1.23829)), \ 
		hc_segment(26/40, 0, hc_power_curve(0.43519))