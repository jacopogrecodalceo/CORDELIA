import mido

def main():
	with mido.open_input() as inport:
		for msg in inport:
			print(msg)

while True:
	main()

