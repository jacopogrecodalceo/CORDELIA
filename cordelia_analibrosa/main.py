from src import yin_algorithm, reconst_signal
from src import show_plot

from const import BASENAME

def main():
	print(f'Processing: {BASENAME}')
	start, dyn, f0 = yin_algorithm()
	show_plot(start, f0)
	reconst_signal(start, f0, n_harm=31)
	
if __name__ == '__main__':
	main()