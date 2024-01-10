import os, shutil
from reaper_python import *

def get_reaper_project_info():
	this_project_dir, buf_size = RPR_GetProjectPath("", 512)
	this_project_dir = os.path.join(this_project_dir, '')

	num, project_name_and_ext, buf_size = RPR_GetProjectName(0, "", 512)
	this_project_name = project_name_and_ext.rsplit(".", 1)[0]

	return this_project_dir, this_project_name

def create_main_dir(directory):
	if os.path.exists(directory):
		shutil.rmtree(directory)

	os.mkdir(directory)

def get_cordelia_instr_paths(instrs, json):
	paths = []
	for instr in instrs:
		path = json[instr]['path']
		paths.append(path)
	return paths

def get_cordelia_gen_paths(gens, json):
	paths = []
	for gen in gens:
		if '$' in gen:
			gen = gen.split('$')[0]
		paths.append(json[gen])
	return paths

