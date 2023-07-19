import random

CORDELIA_NCHNLS = 3

INSTR_HASPLAYED = ['mouth']

def add_element():
    name = f'name_{random.randint(1, 100)}'
    INSTR_HASPLAYED.append(name)

    for each in range(CORDELIA_NCHNLS):
        inc = round((len(INSTR_HASPLAYED) / CORDELIA_NCHNLS) + each)
        print(inc)


def generate_arithmetic_sequence(length, num_elements):
    start = num_elements * (length - 1) + 1
    sequence = [start + i for i in range(num_elements)]
    return sequence

for i in range(1, 5):
    print(generate_arithmetic_sequence(i, CORDELIA_NCHNLS))  # Output: [1, 2]
