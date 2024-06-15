/*
imode -- sum of the following values:

0, 1, or 2: turn off all instances (0), oldest only (1), or newest only (2)
4: only turn off notes with exactly matching (fractional) instrument number, rather than ignoring fractional part
8: only turn off notes with indefinite duration (p3 < 0 or MIDI)
*/

	opcode	turnoff_everything, 0, iSo
imode, Sinstr, ionset xin
schedule "turnoff_everything_instr", ionset, 1, imode, nstrnum(Sinstr)
	endop

	opcode	turnoff_everything, 0, iio
imode, inum, ionset xin
schedule "turnoff_everything_instr", ionset, 1, imode, inum
	endop

	instr turnoff_everything_instr

	turnoff2 p5, p4, 0
	turnoff3 p5
	turnoff
	
	endin
