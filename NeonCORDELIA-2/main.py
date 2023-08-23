from src.parser.parser import Parser

def main():
	# Example input code
	input_code = """



gkpulse = 130

gktuning = scala.pto_diat
;gkarm2_sync_freq = 5

eu: 6, 16, 8
	@careless4;.moij(ntof(g3)*pump(16, fill(1, 1, 2, 3, 1)), .95).moij(ntof(b4)*pump(12, fill(1, 1, 2, 3, 1)), .95)
	wn*once(0, 0, 0, 3)
	fff*4
	bea
	a4: 0, 0, 0, 1
	b4: 0, 0, 0, 1
	g4: 0, 0, 0, 1

eu: 6, 16, 16
	@bebois.revij(qn, .5, .5)
	wn*once(0, 0, 0, 4)
	fff
	iago
	a4: 0, 0, 0, 1
	b4: 0, 0, 0, 1
	g4: 0, 0, 0, 1


@orp: 16, mf*in8m

@dead4: 16, pppp

@drum.cutij(2).sklb3(2asd3): 8, fff

scala.undet

gkpulse = 032

	"""
	parser = Parser(input_code)
	parser.parse()


if __name__ == "__main__":
	main()