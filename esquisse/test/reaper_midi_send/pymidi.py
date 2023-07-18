import mido

def main():
	with mido.open_input() as inport:
		for msg in inport:
			print('----------------------------------------------------------------')
			print(msg)

try:
	main()
	print('1')
except:
	pass