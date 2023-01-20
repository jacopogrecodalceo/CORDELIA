opcode eujo, k, kkkO
	konset, kpulses, kdiv, krot xin

	kphasor	chnget	"heart"

        kph = int( ( ( (kphasor + krot)  * kdiv) % 1) * kpulses)
        keucval = int((konset / kpulses) * kph)

        kold_euc init i(keucval)
        kold_ph init i(kph)


        kres = ((kold_euc != keucval) && (kold_ph != kph)) ? 1 : 0

        kres init i(kres)

        kold_euc = keucval
        kold_ph = kph

        ;print(i(kres))
        ;printk2 kres

        xout kres
endop

