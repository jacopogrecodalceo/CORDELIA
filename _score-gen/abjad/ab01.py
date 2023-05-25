import abjad

voice = abjad.Voice("c'4 d'4 e'4 f'4", name="Voice")
staff = abjad.Staff([voice], name="Staff")
score = abjad.Score([staff], name="Score")
midi_block = abjad.Block("midi")
layout_block = abjad.Block("layout")
score_block = abjad.Block("score", [score, layout_block, midi_block])

lilypond_file = abjad.LilyPondFile([score_block])

abjad.persist.as_midi(lilypond_file, '/Users/j/Desktop/123.mid', remove_ly=True)

#abjad.show(lilypond_file)