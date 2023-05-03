import os

CORDELIA_DIR = '/Users/j/Documents/PROJECTs/CORDELIA/'
CORDELIA_PARTs = ['1-character/', '2-body/', '3-head/']

with open(CORDELIA_DIR + '/_core/include.orc') as f:
    for line in f:
        print(line.strip())
