opcode find_x, i, i
ift xin

indx            init 0
ires            init 0
until ires == 1 do
    ires table indx, ift
    ix = indx
    indx += 1
od
    
    xout ix
    endop

    opcode X_from, i[], iii
ift, ix, idiv xin

indx_step       init 0
ires            init 0
iy_arr[]        init idiv

until indx_step == idiv do
    indx            init 0
    istep           init indx_step*(1/idiv)
    until ires >= istep do
        ires table indx, ift
        iy_arr[indx_step] = indx/ix
        indx += 1
    od

    indx_step += 1
od
    
    xout iy_arr
    endop

    opcode Y_from, i[], ii[]ii
ift, iy_arr[], ix, idiv xin

indx_y          init 0
ires            init 0
ix_arr[]        init idiv

until indx_y == idiv do
    ires table iy_arr[indx_y]*ix, ift
    ix_arr[indx_y] = ires

    indx_y += 1
od
    
    xout ix_arr
    endop

gicedonoi    =   hc_gen(0, gienvdur, 0, 
		hc_segment(1/2, 1, hc_mirror(hc_cubic_curve())), 
		hc_segment(1/2, 1, hc_mirror(hc_cubic_curve())))
		

    opcode  cedonoi, k, ik
itab, kstep xin

idiv            init 88
imin_freq       init ntof("0A")
imax_freq       init ntof("8C")

itab_ref        init gicedonoi

ix_itab_ref   find_x itab_ref
ix_itab       find_x itab

ix_itab_ref[] init idiv
ix_itab[]     init idiv
ifreq_arr[]     init idiv
iy_arr_itab_ref[] init idiv
ix_arr_itab[]   init idiv

iy_arr_itab_ref     X_from itab_ref, ix_itab_ref, idiv
ix_arr_itab         Y_from itab, iy_arr_itab_ref, ix_itab, idiv

kres = imin_freq + (ix_arr_itab[kstep]*imax_freq)

    xout kres
    endop


    
