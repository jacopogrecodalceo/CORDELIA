girosa	hc_gen 0, gienvdur, 0, \ 
		hc_segment(10/38, 0.00674, hc_blackman_curve()), \ 
		hc_segment(1/38, 0.64497, hc_hamming_curve()), \ 
		hc_segment(2/38, 0.04005, hc_blackman_curve()), \ 
		hc_segment(6/38, 0.91184, hc_gaussian_curve(0.32005, 0.66985)), \ 
		hc_segment(1/38, 0.30532, hc_power_curve(0.36154)), \ 
		hc_segment(1/38, 0.06642, hc_hanning_curve()), \ 
		hc_segment(15/38, 0.61433, hc_kiss_curve()), \ 
		hc_segment(1/38, 1, hc_tightrope_walker_curve(0.03106, 0.00669)), \ 
		hc_segment(1/38, 0, hc_kiss_curve())