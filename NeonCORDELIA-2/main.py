from src.parser.parser import Parser

def main():
	# Example input code
	input_code = """


eu: 6, pump(4, fill(1, 3,2)), 2
	r4asd@ixland@solo;.decij(gk1, sr/pump(64, fill(4, 1, 3, 8))).flanij(divz(sn, gk1-2, 0), .65)
	gkbeats*once(8, .25, 1)
	mp
	likearev.a(5)
	1
	2
	3
	4
	5


	"""
	parser = Parser(input_code)
	parser.parse()
	instruments = parser.get_instruments()
	for i in instruments:
		i.print_attributes()
		print('-'*40)

if __name__ == "__main__":
	main()