	opcode eu, k, kkPO
konset, kpulses, kdiv_get, krot xin

kdiv_get approx kdiv_get, 8

if changed2(kdiv_get) == 1 then
	kdiv = kdiv_get
endif

if konset != 0 && kpulses != 0 && kdiv != 0 then

	krot		= krot % kpulses

	kcycle		= chnget:k("heart") * divz(gkdiv, kdiv, 1)

	kph		= int((kcycle % 1) * kpulses) + krot
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
