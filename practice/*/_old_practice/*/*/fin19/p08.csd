set_tempo(65)

instr P1

  set_scale("whole")
  set_root("4D")
 
  euclidplay(3, 
    5,
    "Puck", 
    p3,
    in_scale(-1, 1),
    ampdbfs(-7),
    1,
    random(.5, 4))

endin
