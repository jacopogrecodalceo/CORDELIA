	opcode eu, k, kkPO
konset_get, kpulses, kdiv_get, krot xin

; quantize to the eigth
kdiv_get approx kdiv_get, 8

if changed2(kdiv_get) == 1 then
	kdiv = kdiv_get
endif

kheart chnget "heart"

kvar_last init -1
kvar	= (kheart * gkdiv / 8) % 1
if (kheart > .5) then
	if (kvar < kvar_last) && (random:k(0, 1) > .75) then
		konset = konset_get + floor(random:k(-3, 3))
	endif
else
	konset = konset_get
endif

kvar_last	= kvar

if konset != 0 && kpulses != 0 && kdiv != 0 then

	krot		= krot % kpulses

	kcycle		= kheart * divz(gkdiv, kdiv, 1)
	kph			= (int((kcycle % 1) * kpulses) + krot) % kpulses
	keu_val		= int((konset / kpulses) * kph)

	if changed2(keu_val) == 1 then
		kres = keu_val + 1
	else
		kres = 0
	endif

		xout kres
endif
kdiv	= kdiv_get

	endop
