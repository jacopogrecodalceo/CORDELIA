	opcode dec_to_int, i, i
	inum xin

Snum sprintf "%f", inum
Sdec strsub Snum, strindex(Snum, ".") + 1, strlen(Snum)
Sres strsub Sdec, 0, strindex(Sdec, "0")
ires strtol Sres

	xout ires  
	endop
