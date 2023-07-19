import rtmidi

class MidiHandler:
    def __init__(self):
        self.midi_in = rtmidi.MidiIn()
        self.midi_in.open_port(0)

    def process_messages(self):
        while True:
            message = self.midi_in.get_message()

            if message:
                print(message)


midi_handler = MidiHandler()
midi_handler.process_messages()