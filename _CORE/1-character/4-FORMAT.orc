	instr	abstime

gkabstime	times
	
	endin
	alwayson("abstime")

;	generate date of the score
itim		date
Stim		dates     itim
Syear		strsub    Stim, 22, 24
Smonth		strsub    Stim, 4, 7
Sday		strsub    Stim, 8, 10
iday		strtod    Sday
Shor		strsub    Stim, 11, 13
Smin		strsub    Stim, 14, 16
Ssec		strsub    Stim, 17, 19
Sfilename	sprintf   "%s%s%02d_%s_%s_%s.orc", Syear, Smonth, iday, Shor,Smin, Ssec
gScorename	sprintf    "../_score/%s", Sfilename
