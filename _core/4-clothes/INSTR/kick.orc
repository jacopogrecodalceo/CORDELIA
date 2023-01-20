	instr kick

Sinstr		init "kick"
idur			init p3
iamp			init p4
iftenv		init p5
icps			init p6
ich			init p7

idiv			init icps
iatk			init idur/idiv
isus			init idur*(idiv-1)/idiv

kfreq			expseg icps/24, idur/64, 1, isus, gizero
kamp			cosseg $ampvar, idur, 0
katk			cosseg $ampvar, idur/64, 0

asus 			oscili kamp, icps*kfreq, gitri
aatk 			oscili katk, icps+(icps*4*$ampvar), gisquare

kfiltenv		expseg icps+(icps*4*$ampvar), idur, 21.5

amoog						moogvcf2 asus+aatk, kfiltenv, $ampvar/2
ahp ,alp ,abp, abr	svn amoog, kfiltenv*16, $ampvar/16, $ampvar
;ahp						mvchpf abr, 15

aout						= abr
aout						*= 3
;aout						dcblock2 aout

ienvvar		init idur/1000

	$death


	endin

