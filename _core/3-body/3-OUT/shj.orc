;---TIME
;opcode  ---NAME---, 0, SJJPo
;Sinstr, ktime, kfb, kgain, ich xin

afb     init 0
kdel	= ktime
imaxdel init 5000

;		pre-DELAY
;		vdelay3 works with ms
ad		vdelay3 ain, a(kdel), imaxdel
ad		balance2 ad, ain

afb	 	= ad + (afb * kfb) 

;		REVERB
;		reverb works with s
aout		nreverb ad, kdel$ms, kfb

;		ANAL
kratio		=	kfb*randomi:k(2.25, 2.35, .25)	

ideltime 	=	imaxdel/2

ifftsize 	=	2048
ioverlap 	=	ifftsize / 4 
iwinsize 	=	ifftsize 
iwinshape 	=	1; von-Hann window 

fftin		pvsanal	ad, ifftsize, ioverlap, iwinsize, iwinshape 
fftscale 	pvscale	fftin, kratio, 0, 1 
atrans	 	pvsynth	fftscale 

;		FB
afb 	=	vdelay3(atrans, a(kdel), imaxdel)
