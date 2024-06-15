
def wrapper(instruments):
	
	instr_str_num = 215

	result = []
	for index, each in enumerate(instruments):

		if each:
			num = instr_str_num + index

			status = each[0]
			code = each[1]

			if status == 'alive':

				string = f'\tinstr {num}\n'
				string += code + '\n'
				string += '\tendin\n'

				#(ksmps / sr) * {index+1}
				string += f'turnoff2_i {num}, 0, 1\n'
				string += f'schedule {num}, ksmps / sr, -1\n'
				
				result.append(string)

			elif status == 'dead':
				string = f'turnoff2_i {num}, 0, 1\n'
				result.append(string)
	
	return result

