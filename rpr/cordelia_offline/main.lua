REMOVE_FILEs = true
local script_path = debug.getinfo(1,'S').source:match[[^@?(.*[\/])[^\/]-$]]

path = dofile(script_path .. 'config/paths.lua')

dofile(path.general_functions)

log('everythign doog')