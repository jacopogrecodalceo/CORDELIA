<CsoundSynthesizer>
<CsOptions>
-odac
</CsOptions>
<CsInstruments>

gString			init "--u"

	instr 1
gkph phasor 1/32
	endin

	instr 2

; Concatenate the rhythm into a string
ilen_string		strlen gString
String_raw		init ""
indx			init 0
until indx == ilen_string do
	Spart	strsub gString, indx, indx+1

	if strcmp(Spart, "-") == 0 then
		String_raw strcat String_raw, "10"

	elseif strcmp(Spart, "u") == 0 then
		String_raw strcat String_raw, "1"

	elseif strcmp(Spart, "x") == 0 then
		if random(0, 2) < 1 then
			String_raw strcat String_raw, "10"
		else
			String_raw strcat String_raw, "1"
		endif
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
	ipat[indx]	strtod Spart
	indx += 1
od
	printarray ipat

	endin



</CsInstruments>
<CsScore>
i1 0 96
i2 0 96
</CsScore>
</CsoundSynthesizer>
