opcode jex, k, SkO
	Spat, kdiv, krot xin
	

	korgan	chnget "heart"
	kph	= (korgan * kdiv * gkdiv) % 1

	klast init -1
	ktick init 0
	kpat_indx init 0
	kend_pat init 1	
	Shex init "0"

	if (kph < klast) then

		kstrlen = strlenk(Spat)
		ktick = kph*kstrlen

		if (kstrlen > 0) then

			ktick	+= krot%2
	
			;4 bits/beats per hex value
			kpat_len = strlenk(Spat) * 4
			;get beat within pattern length
			ktick = ktick % kpat_len
			;figure which hex value to use from string
			kpat_indx = int(ktick / 4)
			kend_pat = kpat_indx + 1
			;figure out which bit from hex to use
			kbit_indx = ktick % 4 
			
			Shex		strcatk "0x", strsubk(Spat, kpat_indx, kend_pat)
			;Shex		strcatk "0x", strsubk(Spat, kbeg, kend)
			
			;printks Shex, 0
			;convert individual hex from string to decimal/binary
			kbeat_pat	strtolk Shex
			;kbeat_pat = 0

			;$hex_print

			;bit shift/mask to check onset from hex's bits
			kout = (kbeat_pat >> kbit_indx) & 1 
			
		endif

	else
	
		kout = 0	

	endif
	
	klast	= kph

	xout kout

endop

