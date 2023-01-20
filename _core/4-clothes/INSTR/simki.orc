gisimki_del	init 1+1/nchnls

	instr simki

							$params

idiv						init icps/100

a1			 				oscili $ampvar, icps, gitri

anoi						fractalnoise $ampvar, $ampvar
imax						init .25/icps
klpt						expseg imax, idur, imax-(imax/64)
krvt						expseg idur, idur, idur+(idur/32)
acom1						vcomb anoi, krvt, klpt/int(cosseg(5, idur, 1)), imax

asus						= a1 + balance2(acom1, anoi)*3

katk						cosseg $ampvar, idur/idiv, 0, idur*(idiv-1)/idiv, $ampvar
aatk						oscili katk, icps+(icps*7*$ampvar), gisaw

amoog						moogvcf2 asus+aatk, icps*3/2+(icps*$ampvar)*5, $ampvar
ahp ,alp ,abp, abr	svn amoog, icps*3+(icps*$ampvar), 0, $ampvar

adel						flanger ahp, random:i(-.00125, .00125)+(a(idur/int(gisimki_del))/12), $ampvar
aout						= (adel + abp)*.895

ienvvar					init idur/10

							$death

gisimki_del 			+= 1*(ich-1)

if int(gisimki_del) == 7 then
	gisimki_del init 1+1/nchnls
endif

	endin

