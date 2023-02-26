<CsoundSynthesizer>

<CsOptions>

</CsOptions>


<CsInstruments>

opcode set_root, 0,S 
  Scale_root xin
  
  iscale_root ntom Scale_root

  gi_scale_base = iscale_root
endop

instr 1

Snote = "4C"
inote	ntom	Snote
print(inote)

endin

instr 2

Snote = p4
inote	ntom	Snote
print(inote)

endin

instr 3

set_root("4C")

endin

</CsInstruments>


<CsScore>

i 1 0 .05
i 2 0 .05 "4C"
i 3 0 .05

</CsScore>


</CsoundSynthesizer>