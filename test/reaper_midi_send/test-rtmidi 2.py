import mido

def print_midi_messages():
    # Set up the MIDI input port
    with mido.open_input() as port:
        print("Listening for MIDI messages...")

        # Infinite loop to continuously receive and print MIDI messages
        while True:
            # Receive the next MIDI message
            message = port.receive()

            # Print the MIDI message
            print("Received:", message)

# Call the function to start receiving and printing MIDI messages
print_midi_messages()
