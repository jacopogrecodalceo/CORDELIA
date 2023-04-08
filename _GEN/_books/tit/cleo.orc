gicleo		hc_gen 0, gienvdur, 0, \ 
		hc_segment(29/36, 1, hc_hanning_curve()), \ 
		hc_segment(5/36, 0.34785, hc_tightrope_walker_curve(0.60148, 0.16291)), \ 
		hc_segment(2/36, 0, hc_hamming_curve())
