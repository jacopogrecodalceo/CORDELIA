gipolo	hc_gen 0, gienvdur, 0, \ 
		hc_segment(1/39, 0.17, hc_power_curve(0.82678)), \ 
		hc_segment(2/39, 0.86476, hc_cubic_curve()), \ 
		hc_segment(1/39, 0.40671, hc_gaussian_curve(0.85734, 0.89992)), \ 
		hc_segment(1/39, 0.4743, hc_cubic_curve()), \ 
		hc_segment(1/39, 0.87788, hc_toxoid_curve(1.39059)), \ 
		hc_segment(1/39, 0.17812, hc_kiss_curve()), \ 
		hc_segment(1/39, 1, hc_gaussian_curve(0.72535, 0.24416)), \ 
		hc_segment(1/39, 0.29476, hc_catenary_curve(1.78826)), \ 
		hc_segment(30/39, 0, hc_catenary_curve(0.86282))
