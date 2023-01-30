	instr quit_csound

iesc	init 27
kascii, kpress sensekey

if kascii == iesc && kpress == 1 then
	printks "\n🌊 GOOOOODBYE! 🌊\n", 1
	event "e", 0, 25$ms
	turnoff
endif

	endin
	alwayson("quit_csound")

