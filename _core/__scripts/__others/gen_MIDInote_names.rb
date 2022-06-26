list     = '/Users/j/Documents/PROJECTs/IDRA/_MIDI_note.txt'
file = File.open(list, "w")
file = File.open(list, "a")

sub = 128

128.times do |note|
  begin
    file.write(note.to_s + " ")
  end
  if note < 64
    res = note - 64
    file.write(res.to_s + "\n\n")
  else
    res = (note+1) - 64
    file.write(res.to_s + "\n\n")
  end
end