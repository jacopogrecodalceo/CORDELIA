gkkeyboard_spacebar	init 0

	instr sense_keyboard

iesc	init 27
ispace	init 32

kascii, kpress sensekey

if kascii == ispace && kpress == 1 then 
	gkkeyboard_spacebar = 1
else
	gkkeyboard_spacebar = 0
endif


if kascii == iesc && kpress == 1 then
	printks "\n🌊 GOOOOODBYE! 🌊\n", 1

   /* if gicordelia_serial_handle >= 0 then
      serialFlush gicordelia_serial_handle
      serialEnd gicordelia_serial_handle
      prints "Serial port closed\n"
   endif */

	event "e", 0, 25$ms
	turnoff
endif

	endin
	alwayson("sense_keyboard")






