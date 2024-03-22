	opcode saf, k, SkO
Spat, kdiv, krot xin

; Concatenate the rhythm into a string
ilen_string		strlen Spat
String_raw		init ""
indx			init 0
until indx == ilen_string do
	Spart	strsub Spat, indx, indx+1

	if strcmp(Spart, "-") == 0 then
		String_raw strcat String_raw, "10"

	elseif strcmp(Spart, "u") == 0 then
		String_raw strcat String_raw, "1"

	elseif strcmp(Spart, ".") == 0 then
		String_raw strcat String_raw, "0"

	elseif strcmp(Spart, "x") == 0 then
		String_raw strcat String_raw, "2"

	endif
	indx += 1
od
	;prints String_raw

; Convert the string into an array
ilen_raw		strlen String_raw
ipat[]			init ilen_raw
indx			init 0
until indx == ilen_raw do
	Spart		strsub String_raw, indx, indx+1
	if strcmp(Spart, "0") == 0 then
		ipat[indx]	= 0
	elseif strcmp(Spart, "2") == 0 then
		ipat[indx]	= -1
	else
		ipat[indx]	= indx+1
	endif
	indx += 1
od

kcycle		= chnget:k("heart") * divz(gkdiv, kdiv, 1)
kph			= int((kcycle % 1) * ilen_raw) + krot

kout		= changed2:k(kph) == 1 ? ipat[kph] : 0
kout		= kout < 0 ? samphold:k(int(random:k(0, ilen_raw)), abs(kout)) : kout

	xout kout
	endop
