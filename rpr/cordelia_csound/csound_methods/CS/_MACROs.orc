; ============================================
; TABs
; ============================================
giFILE_nchnls	filenchnls gSfile
indx            init 0
ilimit			max giFILE_nchnls, nchnls
until indx == ilimit do
    ifn     = indx + 1
    ich     = (indx % (giFILE_nchnls <= nchnls ? giFILE_nchnls : nchnls)) + 1
    itab    ftgen ifn, 0, 0, 1, gSfile, 0, 0, ich
    prints  "FN NUMBER: %i with CHANNEL: %i\n", ifn, ich
    indx   += 1
od
giFILE_sr           ftsr 1
giFILE_samp         ftlen 1
giFILE_dur          init giFILE_samp / giFILE_sr
