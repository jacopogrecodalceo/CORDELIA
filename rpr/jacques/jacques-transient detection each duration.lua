local function load_modules(dir)
    local i = 0
    while true do
        local file_name = reaper.EnumerateFiles(dir, i)
        if not file_name then break end

        local mod_name = file_name:match("^func%-(.+)%.lua$")
        if mod_name then
            local file_path = dir .. file_name
            local ok, mod = pcall(dofile, file_path)
            if ok and type(mod) == "table" then
                -- assign module to global variable with the same name as the file suffix
                _G[mod_name] = mod
            end
        end

        i = i + 1
    end
end

local script_path = debug.getinfo(1,'S').source
local script_dir_path = script_path:sub(2):match("(.*/)")
load_modules(script_dir_path)

local script_name = path.get_basename(script_path)
local python_script_parent_path = script_dir_path .. script_name .. '/main.py'

local output_transients_path = script_dir_path ..  script_name .. '/main.txt'

local function wait_for_file_and_create_markers(info)
	local timeout_seconds = info.duration / 2

	local start_time = reaper.time_precise()

	local function check_file()
		local file_exists = reaper.file_exists(output_transients_path)

		if not file_exists then
			local elapsed = reaper.time_precise() - start_time
			if elapsed > timeout_seconds then
				reaper.ShowMessageBox("Timeout: transient file not created after " .. timeout_seconds .. "s", "Error", 0)
				return
			end
			-- File not ready yet, defer and try again
			reaper.defer(check_file)
			return
		end

		-- File exists, read it and create markers
		local file = io.open(output_transients_path, 'r')
		if not file then
			reaper.ShowMessageBox("Could not open transient file: " .. output_transients_path, "Error", 0)
			return
		end

		reaper.Undo_BeginBlock()
		local marker_index = 1
		for line in file:lines() do
			local transient_time = tonumber(line)
			if transient_time then
				local marker_position = info.offset + transient_time
				-- Lua: integer reaper.SetTakeMarker(MediaItem_Take take, integer idx, string nameIn, optional number srcposIn, optional integer colorIn)
				local name = "T" .. marker_index .. ': ' .. string.format("%.2f", transient_time)
				reaper.SetTakeMarker(info.take, marker_index, name, marker_position)
				marker_index = marker_index + 1
			end
		end
		file:close()

		if marker_index == 0 then
			reaper.ShowMessageBox("No transients found in file", "Warning", 0)
			return
		end
		reaper.Undo_EndBlock(script_name, -1)

		reaper.UpdateArrange()
	end
	
	check_file()
end

-- Usage in your main function:
-- read_transients_and_create_markers(output_path, info.offset)

local function main()

	-- get selected items
	local selected_items_ = items.get_selected()
	if #selected_items_ == 0 then useful.error('Select at least 1 item') return end
	if #selected_items_ > 1 then useful.error('Select just 1 item') return end

	-- get input values
	local input_table = {
		{name="dur between transients (ms):", value=500},
		{name="+/- window size (ms):", value=300},
		{name="leading pad (ms):", value=15},
	}
	local values = input.get(script_name, input_table)

	-- validate 
	if not values then return end
	local each_dur = tonumber(values[1])
	if not each_dur then useful.error('Impossible to convert to number') return end
	if each_dur <= 0 then useful.error('Number must be > 0') return end

	local window_size = tonumber(values[2])
	if not window_size then useful.error('Impossible to convert to number') return end
	if window_size <= 0 then useful.error('Number must be > 0') return end

	local leading_pad = tonumber(values[3])
	if not leading_pad then useful.error('Impossible to convert to number') return end
	if leading_pad <= 0 then useful.error('Number must be > 0') return end

	os.remove(output_transients_path)
	--	reaper.PreventUIRefresh(1)
	-- get info item
	for _, item_ in pairs(selected_items_) do
		local info = item.get_info(item_)
		if not info then reaper.ShowMessageBox("Error in getting info from item", "Error", 0) return end
		-- main function
		local command_string = '/opt/homebrew/bin/python3.11 "' .. python_script_parent_path .. '" --input "' .. info.path .. '" --output "' .. output_transients_path .. '" --source_offset ' .. info.offset .. ' --item_dur ' .. info.duration .. ' --each_dur ' .. each_dur .. ' --window_size ' .. window_size .. ' --leading_pad ' .. leading_pad
		command.exec_in_terminal(command_string)
		wait_for_file_and_create_markers(info)
	end

end

main()