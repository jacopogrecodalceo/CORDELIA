;cpstun_render(ntom({note})+int(table:k((chnget:k("heart") * {cycle}) % 1, {tab}, 1)*{limit}), gktuning)

    opcode cpstun_render, k, kk
    kindex, kft xin

kout        cpstun 1, kindex, kft
schedulek   "sense_midi", 0, 1, kindex

    xout kout
    endop
 
