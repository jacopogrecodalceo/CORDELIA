local script_path = debug.getinfo(1,'S').source:match[[^@?(.*[\/])[^\/]-$]]
local validate = dofile(script_path .. '/validate.lua')

local path = {}

path.cordelia = '/Users/j/Documents/PROJECTs/CORDELIA/'
validate.cordelia(path.cordelia)

-- COMMANDS
path.command = {
    sox = '/opt/homebrew/bin/sox',
}
validate.commands(path.command)

-- DIRECTORIES
path.dir = {
    temp = '/Users/j/Documents/temp/',
    methods = path.cordelia .. 'rpr/cordelia_offline/methods/',
}
validate.dirs(path.dir)

-- FILES
path.file = {
    helpers = script_path .. 'helpers.lua',
    instr_json = path.cordelia .. '/cordelia/config/INSTR.json',
    gen_json = path.cordelia .. '/cordelia/config/GEN.json',
}
validate.files(path.file)

return path