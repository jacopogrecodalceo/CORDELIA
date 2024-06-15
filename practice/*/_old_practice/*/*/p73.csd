	instr Score

k1	= $pp + $abslfo($f'1/beatsk(4))

if (eu(2, 16, circle(8, fillarray(12, 16, 17, 16))) == 1) then
	tri("Puck",
	beatsk(.15),
	scall("4C", giminor, circle(1, fillarray(1, 4, 3, 4))),
	scall("4C", gidorian, circle(1, fillarray(1, 4, 3, 7))+1),
	scall("4C", giminor, circle(16, fillarray(6, -1, 1, 4))+9),
	k1)
endif

if (eu(3, 16, circle(8, fillarray(12, 16, 17, 16))) == 1) then
	tri("rePuck",
	beatsk(.15),
	scall("5C", giminor, circle(1, fillarray(1, 4, 3, 4))),
	scall("5C", gidorian, circle(1, fillarray(1, 4, 3, 7))+1),
	scall("5C", giminor, circle(16, fillarray(6, -1, 1, 4))+9),
	k1)
endif


if (eu(3, 16, circle(8, fillarray(16, 16, 17, 16))) == 1) then
	e("Puck",
	beatsk(circle(8, fillarray(.25, .5, .15, .35))),
	scall("4C", gidorian, circle(2, fillarray(5, 5, 6, 7))),
	k1)
endif

if (eu(9, 16, circle(8, fillarray(16, 16, 17, 16))) == 1) then
	e("Juliet",
	beatsk(circle(8, fillarray(.25, .5, .15, .35))),
	scall("4C", gidorian, circle(2, fillarray(5, 5, 6, 7))),
	k1)
endif
	endin
	start("Score")

	instr Route

gkpulse = 135 + lfo(25, .5)

chnset(.85+lfo:k(.125, .15), "Delirium.fb")
chnset(beatsk(1/int(random:k(8, 16)+ int(random:k(0, 2)))), "Delirium.time")

routemeout("Puck", "Delirium")
;softduckmeout("Juliet", "Puck", .005, .05)
routemeout("rePuck", "Bribes")
routemeout("Juliet", "Twinkle")

getmeout("Deliriumson")
getmeout("Deliriumdaughter")
;getmeout("Juliet")
;getmeout("StJacques")

getmeout("rePuck")
getmeout("Puck")

	endin
	start("Route")

