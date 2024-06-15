girose	hc_gen 0, gienvdur, 0, \ 
		hc_segment(1/17, 0.94706, hc_kiss_curve()), \ 
		hc_segment(1/17, 0.11865, hc_gaussian_curve(0.10945, 1.44683)), \ 
		hc_segment(7/17, 1, hc_blackman_curve()), \ 
		hc_segment(1/17, 0.81361, hc_blackman_curve()), \ 
		hc_segment(1/17, 0.45551, hc_toxoid_curve(1.42358)), \ 
		hc_segment(1/17, 0.92456, hc_hamming_curve()), \ 
		hc_segment(1/17, 0.93102, hc_hanning_curve()), \ 
		hc_segment(3/17, 0.53539, hc_cubic_curve()), \ 
		hc_segment(1/17, 0, hc_tightrope_walker_curve(0.84324, 0.58007))