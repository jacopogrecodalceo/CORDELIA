;cpstun_render(ntom({note})+int(table:k((chnget:k("heart") * {cycle}) % 1, {tab}, 1)*{limit}), gktuning)

    opcode cpstun_render, k, kk
    kindex, kft xin

ktrig       init 1

kout        cpstun ktrig, kindex, kft
schedulek   "render_midi_on", 0, 1, kindex

ktrig       += 1

    xout kout
    endop
 
