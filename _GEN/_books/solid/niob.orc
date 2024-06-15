giniob	hc_gen 0, gienvdur, 0, \ 
		hc_segment(3/41, 1, hc_power_curve(0.26545)), \ 
		hc_segment(20/41, 0.62647, hc_blackman_curve()), \ 
		hc_segment(12/41, 0, hc_gaussian_curve(0.59793, 2.13881))