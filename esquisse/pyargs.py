import sys

corfile = sys.argv[1]

with open(corfile, 'r') as f:
    print(f.read())
