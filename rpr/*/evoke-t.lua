function find_orc_files_in_directory(directory_path)
	local orc_files_table = {} -- Table to store basename-path pairs

	local function ends_with(str, ending)
		return str:sub(-#ending) == ending
	end

	local dir_separator = package.config:sub(1,1) -- Get the directory separator based on the OS

	for file in io.popen('ls -1 "'..directory_path..'"'):lines() do
		if ends_with(file, ".orc") then
			local basename, extension = file:match("(.+)%.(.+)")
			orc_files_table[basename] = directory_path .. dir_separator .. file
		end
	end

	return orc_files_table
end

function print_tab(table, indent)
    indent = indent or 0
    local indentStr = string.rep(" ", indent)

    for key, value in pairs(table) do
        if type(value) == "table" then
            print(indentStr .. key .. ": {")
            print_tab(value, indent + 4)
            print(indentStr .. "}")
        else
            print(indentStr .. key .. ": " .. tostring(value))
        end
    end
end

methods = {
	ATS = {
		dir = '/Users/j/Documents/PROJECTs/CORDELIA/rpr/cordelia_instruments/ATS',
		script = '/Users/j/Documents/PROJECTs/CORDELIA/rpr/exec_csound-ATS.py'
	},
	CS = {
		dir = '/Users/j/Documents/PROJECTs/CORDELIA/rpr/cordelia_instruments/CS',
		script = '/Users/j/Documents/PROJECTs/CORDELIA/rpr/exec_csound-CS.py'
	},
	LPC = {
		dir = '/Users/j/Documents/PROJECTs/CORDELIA/rpr/cordelia_instruments/LPC',
		script = '/Users/j/Documents/PROJECTs/CORDELIA/rpr/exec_csound-LPC.py'
	}
}

--[[
CS: {
    files: {
        klast_vco2: /Users/j/Documents/PROJECTs/CORDELIA/rpr/cordelia_instruments/CS/klast_vco2.orc
        buzz_double: /Users/j/Documents/PROJECTs/CORDELIA/rpr/cordelia_instruments/CS/buzz_double.orc
        buzz: /Users/j/Documents/PROJECTs/CORDELIA/rpr/cordelia_instruments/CS/buzz.orc
        fractalnoi_slow: /Users/j/Documents/PROJECTs/CORDELIA/rpr/cordelia_instruments/CS/fractalnoi_slow.orc
        fractalnoi: /Users/j/Documents/PROJECTs/CORDELIA/rpr/cordelia_instruments/CS/fractalnoi.orc
        buzz_double-samphold: /Users/j/Documents/PROJECTs/CORDELIA/rpr/cordelia_instruments/CS/buzz_double-samphold.orc
    }
    script: /Users/j/Documents/PROJECTs/CORDELIA/rpr/exec_csound-CS.py
    dir: /Users/j/Documents/PROJECTs/CORDELIA/rpr/cordelia_instruments/CS
}
]]

local function convert_table(input_table)
    local keys = {}

    for k, _ in pairs(input_table) do
        table.insert(keys, k)
    end

	table.sort(keys)

    return keys
end

for method, tab in pairs(methods) do
	tab.files = find_orc_files_in_directory(tab.dir)
	tab.basenames = convert_table(tab.files)
end

local group_names = {}
local popup_list = {}

for method, tab in pairs(methods) do
	table.insert(group_names, method)
end

table.sort(group_names)

for i, group_name in ipairs(group_names) do
	local files = find_orc_files_in_directory(methods[group_name].dir)
	files = convert_table(files)

	popup_list[#popup_list+1] = group_name
	for j, file in ipairs(files) do
		table.insert(popup_list, file)
	end
end

print_tab(popup_list)