gizeus	hc_gen 0, gienvdur, 0, \ 
		hc_segment(1/21, 1, hc_catenary_curve(1.85031)), \ 
		hc_segment(15/21, 0.00664, hc_tightrope_walker_curve(0.34239, 0.14908)), \ 
		hc_segment(4/21, 0.4503, hc_power_curve(0.77199)), \ 
		hc_segment(1/21, 0, hc_hanning_curve())