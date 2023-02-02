idiv		init 64
iatk		init 3
idec		init 24
isus		init 0.35
irel		init idiv-(iatk+idec)

gitox		hc_hypercurve 0, gienvdur, 0, \
                hc_segment(iatk/idiv, 1, hc_toxoid_curve(.05)), \
                hc_segment(idec/idiv, isus, hc_toxoid_curve(5.95)), \
                hc_segment(irel/idiv, 0, hc_toxoid_curve(.05))
