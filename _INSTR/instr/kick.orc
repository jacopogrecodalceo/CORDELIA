	instr kick

Sinstr		init "kick"
idur			init p3
idyn			init p4
ienv		init p5
icps			init p6
ich			init p7

idiv			init icps
iatk			init idur/idiv
isus			init idur*(idiv-1)/idiv

kfreq			expseg icps/24, idur/64, 1, isus, gizero
kdyn			cosseg $dyn_var, idur, 0
katk			cosseg $dyn_var, idur/64, 0

asus 			oscili kdyn, icps*kfreq, gitri
aatk 			oscili katk, icps+(icps*4*$dyn_var), gisquare

kfiltenv		expseg icps+(icps*4*$dyn_var), idur, 21.5

amoog						moogvcf2 asus+aatk, kfiltenv, $dyn_var/2
ahp ,alp ,abp, abr	svn amoog, kfiltenv*16, $dyn_var/16, $dyn_var
;ahp						mvchpf abr, 15

aout						= abr
aout						*= 3
;aout						dcblock2 aout

$dur_var(1000)

	$end_instr


	

