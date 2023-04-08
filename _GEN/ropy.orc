idiv		= 64

iatk		= 3
idec		= 24
isus		= 0.35
irel		= idiv-(iatk+idec)

giropy		hc_hypercurve 0, gienvdur, 0, \
                hc_segment(iatk/idiv, 1, hc_tightrope_walker_curve(1.105, .125)), \
                hc_segment(idec/idiv, isus, hc_tightrope_walker_curve(.95, .25)), \
                hc_segment(irel/idiv, 0, hc_tightrope_walker_curve(.5, .15))

