import json

cordelia_init_commit = []
cordelia_compile_code = []

cordelia_has = []

with open('./config/basic_token.json', 'r') as f:
	cordelia_basic_token_json = json.load(f)

with open('./config/instr.json', 'r') as f:
	cordelia_instr_json = json.load(f)

with open('./config/gen.json', 'r') as f:
	cordelia_gen_json = json.load(f)

with open('./config/routing.json', 'r') as f:
	cordelia_routing_json = json.load(f)

with open('./config/scala.json', 'r') as f:
	cordelia_scala_json = json.load(f)