gisimki_del	init 1+1/nchnls

	$start_instr(simki)

idiv						init icps/100

a1			 				oscili $dyn_var, icps, gitri

anoi						fractalnoise $dyn_var, $dyn_var
imax						init .25/icps
klpt						expseg imax, idur, imax-(imax/64)
krvt						expseg idur, idur, idur+(idur/32)
acom1						vcomb anoi, krvt, klpt/int(cosseg(5, idur, 1)), imax

asus						= a1 + balance2(acom1, anoi)*3

katk						cosseg $dyn_var, idur/idiv, 0, idur*(idiv-1)/idiv, $dyn_var
aatk						oscili katk, icps+(icps*7*$dyn_var), gisaw

amoog						moogvcf2 asus+aatk, icps*3/2+(icps*$dyn_var)*5, $dyn_var
ahp ,alp ,abp, abr	svn amoog, icps*3+(icps*$dyn_var), 0, $dyn_var

adel						flanger ahp, random:i(-.00125, .00125)+(a(idur/int(gisimki_del))/12), $dyn_var
aout						= (adel + abp)*.895

						$dur_var(10)

gisimki_del 			+= 1*(ich-1)

if int(gisimki_del) == 7 then
	gisimki_del init 1+1/nchnls
endif

	$end_instr

