opcode filter_zero, a, a
	asig xin
	kcnt = 0
	while kcnt < ksmps do
		if(asig[kcnt] == 0) then 
			ksign = asig[kcnt] > 0 ? 1 : -1
			asig[kcnt] = 0.0001 * ksign
		endif
		kcnt += 1
	od

	xout asig
endop


opcode dist_3D, i, iiiiii
	ix1,iy1,iz1,ix2,iy2,iz2 xin
	ires = sqrt( pow(ix2 - ix1, 2) + pow(iy2 - iy1, 2) + pow(iz2 - iz1, 2)  )
	xout ires
endop

opcode dist_3D, k, kkkkkk
	kx1,ky1,kz1,kx2,ky2,kz2 xin
	kres = sqrt( pow(kx2 - kx1, 2) + pow(ky2 - ky1, 2) + pow(kz2 - kz1, 2)  )
	xout kres
endop

opcode dist_3D, a, aaaaaa
	ax1,ay1,az1,ax2,ay2,az2 xin
	ares = sqrt( pow(ax2 - ax1, 2) + pow(ay2 - ay1, 2) + pow(az2 - az1, 2)  )
	xout ares
endop

opcode xyz_to_aed, aaa,aaa
	ax, ay, az xin
	aRad = sqrt( (ax * ax) + (ay * ay) + (az * az) )
	// Careful, must not be 0 (0 distance is veryyyy close)
	aRad = filter_zero(aRad)

	aInc = cosinv( az / aRad)
	aElev = ($M_PI / 2)  - aInc
	aaZ = taninv2(ay, ax)
 	xout  aaZ, aElev, aRad
endop

opcode aed_to_xyz, aaa, aaa
	aa,ae,ad xin
	; Warning here, division by 0
	az =  sqrt( pow(ad, 2) * pow(cos(aa), 2) / (1 + pow(cos(aa), 2) * pow(tan(ae), 2)))
	ax = az * tan(aa)
	ay = az * tan(ae)
	xout ax, ay, az
endop

opcode xyz_to_aed, kkk, kkk
	kx, ky, kz xin
	kRad = sqrt( (kx * kx) + (ky * ky) + (kz * kz) )
	// Careful, must not be 0 (0 distance is veryyyy close)
	if(kRad == 0) then 
		ksign = (kRad > 0) ? 1 : -1
		kRad = 0.00001  * ksign
	endif
	kInc = cosinv( kz / kRad)
	kElev = ($M_PI / 2)  - kInc
	kaZ = taninv2(ky, kx)
 	xout  kaZ, kElev, kRad
endop

opcode aed_to_xyz, kkk, kkk
	ka,ke,kd xin
	; Warning here, division by 0
	kz =  sqrt( pow(kd, 2) * pow(cos(ka), 2) / (1 + pow(cos(ka), 2) * pow(tan(ke), 2)))
	kx = kz * tan(ka)
	ky = kz * tan(ke)
	xout kx, ky, kz
endop


// Inspired from https://www.modulargrid.net/e/worng-electronics-vector-space

	/* 
		Outputs descriptions : 
			* kdA, kdB, kdC, kdD = distances of point to front angles 
			* kdAd, kdBd, kdCd, kdDd = distances of point to back angles 
			* KdCenter, kIdCenter = distance of points to Center, and invert of it 
			* KdNear = distance of point to nearest point of the unit sphere within the cube
			* ksum1, 2, etc = custom cook : kind of something summing and rectifying signals and rescaling them again
	*/


opcode vector_space, a[], aaa
	ax, ay, az xin

	aouts[] init 8

	imaxdist = dist_3D(-1, -1, -1, 1, 1, 1)
	imult_max = 1 / imaxdist

	iA[] fillarray -1, 1, -1
	iB[] fillarray 1, 1, -1
	iC[] fillarray -1, -1, -1
	iD[] fillarray 1, -1, -1

	iAd[] fillarray -1, 1, 1
	iBd[] fillarray 1, 1, 1
	iCd[] fillarray -1, -1, 1
	iDd[] fillarray 1, -1, 1

	aouts[0] = dist_3D(ax, ay, az, a(iA[0]), a(iA[1]), a(iA[2])) * imult_max
	aouts[1] = dist_3D(ax, ay, az, a(iB[0]), a(iB[1]), a(iB[2])) * imult_max
	aouts[2] = dist_3D(ax, ay, az, a(iC[0]), a(iC[1]), a(iC[2])) * imult_max
	aouts[3] = dist_3D(ax, ay, az, a(iD[0]), a(iD[1]), a(iD[2])) * imult_max

	aouts[4] = dist_3D(ax, ay, az, a(iAd[0]), a(iAd[1]), a(iAd[2])) * imult_max
	aouts[5] = dist_3D(ax, ay, az, a(iBd[0]), a(iBd[1]), a(iBd[2])) * imult_max
	aouts[6] = dist_3D(ax, ay, az, a(iCd[0]), a(iCd[1]), a(iCd[2])) * imult_max
	aouts[7] = dist_3D(ax, ay, az, a(iDd[0]), a(iDd[1]), a(iDd[2])) * imult_max

	xout aouts

endop


giquad_index init 0

	$start_instr(quad)

ax = oscili(1, icps+(lfo(icps-(11/10*icps), random:i(3, 5)))*cosseg(0, idur/2, 1, idur/2, 0)/cosseg(9, idur, 3))
ay = oscili(1/6, icps*$M_PI)

az = oscili(1/3, icps*11/5) 


kphase = gkbeatf / idur

aouts[] vector_space ax*abs(oscili(1, kphase, gisine, 0)), ay*abs(oscili(1, kphase, gisine, 1/3)), az*abs(oscili(1, kphase, gisine, 2/3))

index init (ich-1)+int(giquad_index)

;print index 

aout = aouts[index]

;aout		dcblock2 aout

aout		*= $dyn_var+(lfo($dyn_var/4, i(gkbeats)))

giquad_index += 1

if giquad_index == 7 then
	giquad_index = 0
endif

	$dur_var(10)
	$end_instr
