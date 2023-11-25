<CsoundSynthesizer>
<CsOptions>
-odac
</CsOptions>
<CsInstruments>

0dbfs=1
nchnls=2

	instr 1
gkph phasor 1/32
	endin

	instr 2
String			init "--u"
ilen_string		strlen String

iraw_pat[]		init ilen_string
indx			init 0
internal_indx = 0
until indx == ilen_string do
	Spart	strsub String, indx, indx+1

	if strcmp(Spart, "-") == 0 then
		iraw_pat[indx] = 10
	elseif strcmp(Spart, "u") == 0 then
		iraw_pat[indx] = 1
	elseif strcmp(Spart, "x") == 0 then
		if random(0, 2) < 1 then
			iraw_pat[indx] = 10
		else
			iraw_pat[indx] = 1
		endif
	endif
	indx += 1

od
	printarray iraw_pat

ilen_pat		lenarray iraw_pat
imain_pat		init ilen_pat
indx			init 0
until indx == ilen_pat do
	if iraw_pat[indx] == 10 then
		imain_pat
od



	endin




</CsInstruments>
<CsScore>
i1 0 96
i2 0 96
</CsScore>
</CsoundSynthesizer>
