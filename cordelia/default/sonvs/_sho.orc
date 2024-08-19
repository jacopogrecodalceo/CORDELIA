/*
giorp_ch			init 2
gSorp_file_1		init "/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/orp.wav"
giorp_1				ftgen 0, 0, 0, 1, gSorp_file_1, 0, 0, 1
giorp_2				ftgen 0, 0, 0, 1, gSorp_file_1, 0, 0, 2
giorp_list[]		fillarray giorp_1, giorp_2
*/

gi---NAME---_len		init lenarray(gi---NAME---_list)/gi---NAME---_ch
gk---NAME---_voices		init 8
gi---NAME---_samps		ftlen gi---NAME---_1
gi---NAME---_jitter		init 128

instr ---NAME---
	$params(---NAME---)

	ivoice init 0
	ivoices	i gk---NAME---_voices
	until ivoice == ivoices do
		;idec	init ((ich-1) * gk---NAME---_voices) + ivoice
		;inum	init nstrnum("---NAME---_original")+idec/1000
		schedule "---NAME---_original", 0, idur, idyn, ienv, icps, ich, ivoice, ivoices
		ivoice += 1
	od
	turnoff

endin

instr ---NAME---_original
	$params(---NAME---)

	ivoice 				init p8
	ivoices				init p9
	iphase				init ivoice / ivoices

	icps 				/= 128

	aphasor				phasor icps, iphase
	awin				table3 aphasor, gihanning, 1

;* samphold:a(gadur, aphasor)
;	asum1		= aphasor * 1/icps
	asamp		samphold a(1/icps), aphasor
	asum1		= aphasor * asamp
	asum2		samphold chnget:a("heart_a")*(gi---NAME---_samps / sr), aphasor
	andx		= (asum1+asum2) * sr

	aout				table3 (andx + a(jitter:k(gi---NAME---_jitter, 3.5, 5))) % gi---NAME---_samps, gi---NAME---_list[(ich-1)%gi---NAME---_len]
	aout				*= awin

	aout	/= ivoices/3
	aout	*= $dyn_var

	$dur_var(10)
	aout	*= envgen(idur_var, ienv)
	chnmix 	aout, sprintf("%s_%i", Sinstr, ich)
endin