	opcode eu, k, kkPO
konset_get, kpulses, kdiv_get, krot xin

; quantize to the eigth
kdiv_get approx kdiv_get, 8

if changed2(kdiv_get) == 1 then
	kdiv = kdiv_get
endif

kheart chnget "heart"
kcycle = kheart * divz(gkdiv, kdiv, 1)

kvar_last init -1
kvar	= kcycle % 1

if kcycle < (kdiv - 1) then
	if (kvar < kvar_last) && (random:k(0, 1) > .5) then
		konset = konset_get + floor(random:k(-3, 3))
		while konset > kpulses do
			konset = konset_get + floor(random:k(-3, 3))
		od
	endif
else
	konset = konset_get
endif
	printks2 "\nEU ONSET IS CHANGED: %i\n", konset

kvar_last	= kvar

if konset != 0 && kpulses != 0 && kdiv != 0 then

	krot		= krot % kpulses

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
