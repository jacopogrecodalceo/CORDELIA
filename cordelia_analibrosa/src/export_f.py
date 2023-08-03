import numpy as np
from pathlib import Path

from const import OUTPUT_DIR, BASENAME, INSTR

def export_dur_fixed(func, stack):
	filename = OUTPUT_DIR / Path(f'{BASENAME}-{func.__name__}-dur_fixed.sco')
	dur = 3.5
	code = []
	for start, dyn, freq in stack.astype(str):
		code.append('\t\t\t'.join(['i', str(INSTR), start, str(dur), dyn, freq]))
	with open(filename, 'w') as f:
		f.write('\n'.join(code))
	print('File saved to: %s' % filename)

def export_legato(func, stack):
	filename = OUTPUT_DIR / Path(f'{BASENAME}-{func.__name__}-legato.sco')
	extract_start = stack[:, 0]
	dur_array = np.diff(extract_start)
	ending_dur = 5
	dur_array = np.append(dur_array, ending_dur)
	stack_legato = np.insert(stack, 1, dur_array, axis=1)
	code = []
	for start, dur, dyn, freq in stack_legato.astype(str):
		code.append('\t\t\t'.join(['i', str(INSTR), start, dur, dyn, freq]))
	with open(filename, 'w') as f:
		f.write('\n'.join(code))

	print('File saved to: %s' % filename)

def export_epsilon(func, stack, epsilon_cents):
	filename = OUTPUT_DIR / Path(f'{BASENAME}-{func.__name__}-epsilon{epsilon_cents}.sco')

	# Convert frequencies to cents
	cents = 1200 * np.log2(stack[:, 2] / stack[0, 2])

	# Define epsilon value in cents for comparison

	# Use np.isclose with the atol parameter to compare cents (excluding the first row)
	is_same_freq = np.isclose(cents[1:], cents[:-1], atol=epsilon_cents)

	# Update values in the first column based on the condition (excluding the first row)
	stack[1:, 0][is_same_freq] = np.nan

	mask = ~np.isnan(stack).any(axis=1)

	# Use the mask to get the elements without NaN
	stack_without_nan = stack[mask]

	extract_start = stack_without_nan[:, 0]
	dur_array = np.diff(extract_start)
	ending_dur = 5
	dur_array = np.append(dur_array, ending_dur)
	stack_epsilon = np.insert(stack_without_nan, 1, dur_array, axis=1)
	code = []
	for start, dur, dyn, freq in stack_epsilon.astype(str):
		code.append('\t\t\t'.join(['i', str(INSTR), start, dur, dyn, freq]))
	with open(filename, 'w') as f:
		f.write('\n'.join(code))

	print('File saved to: %s' % filename)

def export():
	def decorator(func):
		def wrapper(*args, **kwargs):
			
			result = func(*args, **kwargs)
			stack = np.column_stack(result)
			np.savetxt(OUTPUT_DIR / Path(f'{BASENAME}-{func.__name__}-stack.txt'), stack, delimiter=',\t\t\t', fmt='%s')

			# Create a boolean mask to identify NaN elements
			mask = ~np.isnan(stack).any(axis=1)

			# Use the mask to get the elements without NaN
			stack_without_nan = stack[mask]

			# Remove rows containing zeros
			stack_without_zeros = stack_without_nan[~np.any(stack_without_nan == 0, axis=1)]

			export_dur_fixed(func, stack_without_zeros)
			export_epsilon(func, stack_without_zeros, epsilon_cents = 115)
			export_epsilon(func, stack_without_zeros, epsilon_cents = 65)


			return result
		return wrapper
	return decorator
