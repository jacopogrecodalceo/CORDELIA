    opcode edo, i, Sii
Sroot, iedo, ideg xin

icps    mtof ntom(Sroot)

ioctave = floor(((ideg-1)/iedo))+1
istep = (ideg-1)%iedo 
irange = (icps*ioctave)/iedo
ires    = icps*(2^ioctave)+(irange*istep)

    xout ires
    endop

    opcode edo, k, Skk
Sroot, kedo, kdeg xin

kcps    mtof ntom(Sroot)
kstep   = kcps/kedo

kres    = kcps+(kdeg*kstep)

    xout kres
    endop

    opcode rpredo, i, Sii
Sroot, iedo, ideg xin

icps    mtof ntom(Sroot)

ioctave = floor(((ideg-1)/iedo))+1
istep = (ideg-1)%iedo 
irange = (icps*ioctave)/iedo
ires    = icps*(2^ioctave)+(irange*istep)

	prints "%s\n", mton(ftom(ires))

    xout ires
    endop
