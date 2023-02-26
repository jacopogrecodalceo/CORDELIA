	opcode eu, k, kkPO
konset, kpulses, kdiv, krot xin

krot		= krot % kpulses

kcycle		= chnget:k("heart") * (gkdiv/kdiv)

kph			= int((kcycle % 1) * kpulses) + krot
keu_val		= int((konset / kpulses) * kph)

klast_eu	init i(keu_val)
klast_ph	init i(kph)

kres		= ((klast_eu != keu_val) && (klast_ph != kph)) ? 1 : 0

kres		init i(kres)

klast_eu	= keu_val
klast_ph	= kph


	xout kres

	endop
