################################################################################
"""
This example uses two copies of the same composer to generate the two
piano parts in Steve Reich's Piano Phase.

To run this script cd to the parent directory of demos/ and do:
```bash
python3 -m demos.reich
```
"""


from musx import Note, Seq, Score, MidiFile, cycle, keynum

import random

import random

def generate_pat(index):
    # define the characters and numbers to use
    chars = ['a', 'b', 'c', 'd', 'e', 'f', 'g']
    nums = [str(i) for i in range(2, 5)]
    
    # create a list of random characters and numbers
    rand_list = []
    for i in range(index):
        rand_char = random.choice(chars)
        rand_num = random.choice(nums)
        rand_list.append(rand_char)
        rand_list.append(rand_num)
    
    # convert the list to a string with numbers not separated by spaces
    rand_string = ""
    for item in rand_list:
        if item.isdigit():
            if random.choice([True, False]):
                rand_string += item
        else:
            rand_string += f" {item}"
    
    return rand_string.strip()




def piano_phase(score, end, keys, rate):
    """
    Composes a piano part for Steve Reich's Piano Phase.

    Parameters
    ----------
    score : Score
        The scheduling queue to run the composer in.
    end : int | float
        The total duration of the piece.
    keys : list
        A list of midi key numbers to play in a loop.
    rate : int | float
        The rhythm to use.    
    """
    # Create a cyclic pattern to produce the key numbers.
    pattern = cycle(keys)
    # Stop playing when score time is >= end.
    while score.now < end:
        # Get the next key number.
        knum = next(pattern)
        # Create a midi note to play it.
        note = Note(time=score.now, duration=rate, pitch=knum, amplitude=.75)
        # Add the midi note to the score.
        score.add(note)
        # Return the amount of time until this composer runs again.
        yield rate


if __name__ == '__main__':
    # It's good practice to add any metadata such as tempo, midi instrument
    # assignments, micro tuning, etc. to track 0 in your midi file.
    track0 = MidiFile.metatrack()
    # Track 1 will hold the composition.
    track1 = Seq()
    # Create a score and give it tr1 to hold the score event data.
    score = Score(out=track1)
    # Convert Reich's notes to a list of midi key numbers to phase.
    pat = generate_pat(24)
    print(pat)
    keys = keynum(pat)
    # Create two composer generators that run at slightly different 
    # rates and cause the phase effect.
    end = 60
    pianos = [piano_phase(score, end, keys, .30), 
              piano_phase(score, end, keys, .25)]
    # Create the composition.
    score.compose(pianos)
    # Write the tracks to a midi file in the current directory.
    file=MidiFile("phas.mid", [track0, track1]).write()
    print(f"Wrote '{file.pathname}'.")
    
    # To automatially play demos use setmidiplayer() and playfile().
    # Example:
    #     setmidiplayer("fluidsynth -iq -g1 /usr/local/sf/MuseScore_General.sf2")
    #     playfile(file.pathname)