#define hex_print
#
if kbit_indx==0 then
	if	kbeat_pat==0 then
		printks	"				𝄿 𝄿 𝄿 𝄿\n", 0
		printks "				%s\n", 0, Shex
	elseif	kbeat_pat==1 then
		printks	"				𝄿 𝄿 𝄿 𝅘𝅥𝅯\n", 0
		printks "				%s\n", 0, Shex
	elseif	kbeat_pat==2 then
		printks	"				𝄿 𝄿 𝅘𝅥𝅯 𝄿\n", 0
		printks "				%s\n", 0, Shex
	elseif	kbeat_pat==3 then
		printks	"				𝄿 𝄿 𝅘𝅥𝅯 𝅘𝅥𝅯\n", 0
		printks "				%s\n", 0, Shex
	elseif	kbeat_pat==4 then
		printks	"				𝄿 𝅘𝅥𝅯 𝄿 𝄿\n", 0
		printks "				%s\n", 0, Shex
	elseif	kbeat_pat==5 then
		printks	"				𝄿 𝅘𝅥𝅯 𝄿 𝅘𝅥𝅯\n", 0
		printks "				%s\n", 0, Shex
	elseif	kbeat_pat==6 then
		printks	"				𝄿 𝄿 𝄿 𝅘𝅥𝅯\n", 0
		printks "				%s\n", 0, Shex
	elseif	kbeat_pat==7 then
		printks	"				𝄿 𝅘𝅥𝅯 𝅘𝅥𝅯 𝅘𝅥𝅯\n", 0
		printks "				%s\n", 0, Shex
	elseif	kbeat_pat==8 then
		printks	"				𝅘𝅥𝅯 𝄿 𝄿 𝄿\n", 0
		printks "				%s\n", 0, Shex
	elseif	kbeat_pat==9 then
		printks	"				𝅘𝅥𝅯 𝄿 𝄿 𝅘𝅥𝅯\n", 0
		printks "				%s\n", 0, Shex
	elseif	kbeat_pat==10 then
		printks	"				𝅘𝅥𝅯 𝄿 𝅘𝅥𝅯 𝄿\n", 0
		printks "				%s\n", 0, Shex
	elseif	kbeat_pat==11 then
		printks	"				𝅘𝅥𝅯 𝄿 𝅘𝅥𝅯 𝅘𝅥𝅯\n", 0
		printks "				%s\n", 0, Shex
	elseif	kbeat_pat==12 then
		printks	"				𝅘𝅥𝅯 𝅘𝅥𝅯 𝄿 𝄿\n", 0
		printks "				%s\n", 0, Shex
	elseif	kbeat_pat==13 then
		printks	"				𝅘𝅥𝅯 𝅘𝅥𝅯 𝄿 𝅘𝅥𝅯\n", 0
		printks "				%s\n", 0, Shex
	elseif	kbeat_pat==14 then
		printks	"				𝅘𝅥𝅯 𝅘𝅥𝅯 𝅘𝅥𝅯 𝄿\n", 0
		printks "				%s\n", 0, Shex
	elseif	kbeat_pat==15 then
		printks	"				𝅘𝅥𝅯 𝅘𝅥𝅯 𝅘𝅥𝅯 𝅘𝅥𝅯\n", 0
		printks "				%s\n", 0, Shex
	endif
endif
#


opcode hex, k, SkO
	Spat, kdiv, krot xin

	korgan	chnget "heart"
	kph	= (korgan * kdiv) % (1/16)

	klast init -1
	ktick init 0
	kpat_indx init 0
	kend_pat init 1	
	Shex init "0"
	
	if (kph < klast) then

		ktick += 1

		kstrlen = strlenk(Spat)

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

			$hex_print

			;bit shift/mask to check onset from hex's bits
			kout = (kbeat_pat >> (3 - kbit_indx)) & 1 
			
		endif

	else
	
		kout = 0	

	endif
	
	klast	= kph

	xout kout

endop



