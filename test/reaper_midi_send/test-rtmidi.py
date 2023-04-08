import rtmidi

# Create an input MIDI port (replace 'My MIDI Device' with the name of your MIDI device)
midi_in = rtmidi.RtMidiIn()
midi_in.openVirtualPort("PY-RTMIDI")

# Loop forever, printing incoming MIDI messages
while True:
    msg = midi_in.getMessage()
    if msg:
        print(msg)
