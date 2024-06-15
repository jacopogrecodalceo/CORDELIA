gilear	hc_gen 0, gienvdur, 0, \ 
		hc_segment(1/56, 1, hc_toxoid_curve(2.38406)), \ 
		hc_segment(1/56, 0.21285, hc_hamming_curve()), \ 
		hc_segment(2/56, 0.95781, hc_hanning_curve()), \ 
		hc_segment(3/56, 0.57434, hc_hanning_curve()), \ 
		hc_segment(1/56, 0.0059, hc_cubic_curve()), \ 
		hc_segment(2/56, 0.1689, hc_toxoid_curve(0.21805)), \ 
		hc_segment(44/56, 0.01586, hc_gaussian_curve(0.40576, 0.03333)), \ 
		hc_segment(1/56, 0.72855, hc_hamming_curve()), \ 
		hc_segment(1/56, 0, hc_power_curve(0.10998))