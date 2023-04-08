giiago	hc_gen 0, gienvdur, 0, \ 
		hc_segment(1/42, 1, hc_blackman_curve()), \ 
		hc_segment(11/42, 0.43504, hc_catenary_curve(1.75998)), \ 
		hc_segment(1/42, 0.08958, hc_cubic_curve()), \ 
		hc_segment(2/42, 0.40723, hc_power_curve(0.76874)), \ 
		hc_segment(27/42, 0, hc_catenary_curve(0.80227))