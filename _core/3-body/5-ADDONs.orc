	instr clock_sender

aph_init	chnget "heart_a"

aph		= aph_init
;aph		delay aph_init, gidelayclock

		outch gimainclock_ch, aph
		outch giquarterclock_ch, (aph*64)%1

	endin
	alwayson("clock_sender")

