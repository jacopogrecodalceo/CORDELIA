import os

from make import include, gen, instr, routing, scala, tokens

cordelia_dir = '/Users/j/Documents/PROJECTs/CORDELIA/'

include_dir = './csound_cordelia/'
include_orc = os.path.join(include_dir, 'include.orc')

gen_dir = os.path.join(cordelia_dir, '_GEN')
gen_json = './config/GEN.json'

instr_dir = os.path.join(cordelia_dir, '_INSTR')
instr_json = './config/INSTR.json'

routing_dir = os.path.join(cordelia_dir, '_MOD')
routing_json = './config/ROUTING.json'
routing_orc = os.path.join(cordelia_dir, '_cordelia', 'csound_cordelia', '3-body', '3-MOD.orc')

scala_dir = os.path.join(cordelia_dir, '_SCALA')
scala_json = './config/SCALA.json'

tokens_json = 'config/tokens.json'

def main():

	print('Processing INCLUDE')
	include.make(include_orc, include_dir)
	
	print('Processing GEN')
	gen.make(gen_dir, gen_json)

	print('Processing INSTR')
	instr.make(instr_dir, instr_json)

	print('Processing ROUTING')
	routing.make(routing_orc, routing_dir, routing_json)
	
	print('Processing SCALA')
	scala.make(scala_dir, scala_json)

	print('Processing TOKENs')
	tokens.make(routing_json, tokens_json)

if __name__ == "__main__":
	main()