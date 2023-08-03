import json
import time

def measure_time(func):
	def wrapper(*args, **kwargs):
		start_time = time.time()
		result = func(*args, **kwargs)
		end_time = time.time()
		execution_time = end_time - start_time
		print(f"Execution time of {func.__name__}: {execution_time} seconds")
		return result
	return wrapper

json_file = "/Users/j/Documents/PROJECTs/CORDELIA/_setting/instr.json"

with open(json_file) as file:
	json_data = json.load(file)

@measure_time
def binary_search(json_data, key):
	low = 0
	high = len(json_data) - 1

	while low <= high:
		mid = (low + high) // 2
		mid_key = list(json_data.keys())[mid]

		if mid_key == key:
			return json_data[key]
		elif mid_key < key:
			low = mid + 1
		else:
			high = mid - 1

	return None

@measure_time
def linear_search(json_data, key):
	for item_key, item_value in json_data.items():
		if item_key == key:
			return item_value
	return None

if __name__ == '__main__':
		
	print(len(json_data))

	key_to_find = 'mhon2'
	value = binary_search(json_data, key_to_find)

	if value is not None:
		print(f"Value associated with '{key_to_find}': {value}")
	else:
		print(f"Key '{key_to_find}' not found in the JSON file.")
	
	value = linear_search(json_data, key_to_find)

	if value is not None:
		print(f"Value associated with '{key_to_find}': {value}")
	else:
		print(f"Key '{key_to_find}' not found in the JSON file.")

