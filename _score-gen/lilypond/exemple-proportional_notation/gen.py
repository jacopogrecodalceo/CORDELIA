import random
import os

from dataclasses import dataclass

@dataclass
class Event:
    instr_name = str
    start_pos = float
    dur = float
    note = str
    cent = float

event = Event
with open(f'{os.getcwd()}/gen.txt', 'w') as f:

    string =[]

    names = ['cordelia', 'goneril', 'regan']
    notes = 'abcdefg'

    last_start_pos = ''
    event.start_pos = round(random.random()*12, 2)
    
    for i in range(512):
    
        event.instr_name = names[random.randint(0, len(names)-1)]

        if random.random() > .5:
            event.start_pos = round(random.random()*64, 2)
        event.note = notes[random.randint(0, len(notes)-1)]
        event.dur = 1
        event.cent = round(50 - random.random()*100, 2)

        if event.cent > 0:
            event.cent = f'+{event.cent}'

        #function name
        string.append('\\at')
        string.append(event.instr_name)
        string.append(f'##e{event.start_pos}')
        string.append(f'{event.note}\'')
        string.append(f'##e{event.dur}')
        string.append(f'"{event.cent}¢"')
        if event.start_pos != last_start_pos:
            string.append(f'"{event.start_pos}s"')
        else:
            string.append(f'""')
        f.write(' '.join(string))
        f.write('\n')
        string.clear()
        last_start_pos = event.start_pos
