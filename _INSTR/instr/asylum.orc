
;gkasylum_chs[] init 4
chnset 0, "oc"
	$start_instr(asylum)
if ich == 1 then
	iserial_ch floor icps % 4

		$dur_var(10)
	aenv envgen idur_var, ienv
	chnset k(aenv), "oc"

else
	turnoff
endif
	endin

/* 	instr asylum_instr
iserial_ch init p4
gkasylum_chs[iserial_ch] init p5
	turnoff
	endin

	instr asylum_control

iserial_ch init p4

kval int gkasylum_chs[iserial_ch]*gicordelia_serial_dac_max
kmsb = (kval >> 8) & 0xFF
klsb = kval & 0xFF

; Write packet every k-cycle
serialWrite gicordelia_serial_handle, iserial_ch
serialWrite gicordelia_serial_handle, kmsb
serialWrite gicordelia_serial_handle, klsb
	prints sprintf("ASYLUM SERIAL %i\n", iserial_ch)

	printk2 kval
	endin

indx init 0
until indx == lenarray(gkasylum_chs) do
	schedule nstrnum("asylum_control")+(indx+1)/1000, 0, -1, indx
	indx += 1
od */
