	instr Score

root("3B")
gamme("locrian")

kdyn	= abs(lfo:k(.35, 1/beats(1), 3))

if	(eu(12, 64, 8) == 1) then
	e("Puck",
	$med,
	in_scale(0, circle(5, fillarray(1, 2, 6)) + circle(3, fillarray(-5, -7))),
	kdyn,
	$med)
endif

if	(eu(12, 64, 4) == 1) then
	e("Puck",
	$long,
	in_scale(1, circle(5, fillarray(1, 2, 6)) + circle(3, fillarray(-5, -7) - 2)),
	$ff,
	$long)
endif

if	(eu(5, 9, 3) == 1) then
	e("rePuck",
	$short,
	in_scale(1, circle(2, fillarray(1, 2, 7))),
	$mf,
	$short)
elseif	(eu(5, 9, 3) == 1) then
	e("rePuck",
	$short,
	in_scale(2, circle(2, fillarray(2, 1, 6))),
	$mf,
	$short)
endif

;routemeout("rePuck", "delirium")
;routemeout("Puck", "K35")
;routemeout("Puck", "Moog")
	
chnset(600 + lfo:k(300, 1), "Moog.freq")
;chnset( abs(lfo:k(1, .05)), "delirium.time")
;chnset(.75, "delirium.fb")

kamp	= .5 + abs(lfo:k(.5, 1/beats(8)))


routemeout("Puck", "Moog")
;getmeout("Moog")
;routemeout("rePuck", "Moog")
;routemeout("Puck", "delirium", .5)

;getmeout("rePuck")
;getmeout("Puck", 1)
;getmeout("rePuck", .2)

;getmeto("Puck", "givemelife")

	endin

set_tempo(141)

start("Score")
