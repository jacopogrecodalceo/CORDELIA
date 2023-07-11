import rtmidi

# Create an input MIDI port (replace 'My MIDI Device' with the name of your MIDI device)
midi = rtmidi.RtMidiIn()

available_ports = midi.getPort()

print(available_ports)

midi.openPort(1)

# Loop forever, printing incoming MIDI messages
while True:
    msg = midi.getMessage()
    if msg:
        print(msg)
