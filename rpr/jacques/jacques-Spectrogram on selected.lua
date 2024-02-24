SCRIPT_PATH = '/opt/homebrew/bin/python3 /Users/j/Documents/CLI/cordelia-ghost/cordelia-ghost.py'

local function get_selected_items()
	-- Get the number of selected items
	local num_selected_items = reaper.CountSelectedMediaItems(0)

	local selected_items = {}
	-- Iterate over selected items
	for i = 0, num_selected_items - 1 do
		-- Get the selected item at index i
		table.insert(selected_items, reaper.GetSelectedMediaItem(0, i))
	end
	return selected_items
end

local function get_info_item(item)
	-- Check if the selected item contains an audio source
	local take = reaper.GetActiveTake(item)
	if take ~= nil and reaper.TakeIsMIDI(take) == false then
		local source = reaper.GetMediaItemTake_Source(take)
		local filename = reaper.GetMediaSourceFileName(source)
		local onset = reaper.GetMediaItemTakeInfo_Value(take, 'D_STARTOFFS')
		local duration = reaper.GetMediaItemInfo_Value(item, 'D_LENGTH')
		return filename, onset, duration
	end

end

local function main(directory, color, flags)
	local selected_items = get_selected_items()

	for _, item in ipairs(selected_items) do
		local filename, onset, duration = get_info_item(item)
		local cmd = SCRIPT_PATH .. ' "' .. filename .. '"'
		--cmd = cmd .. ' -e -g -t'
		cmd = cmd .. ' -s ' .. onset
		cmd = cmd .. ' -d ' .. duration
		cmd = cmd .. ' -o "' .. directory .. '"'

		if color ~= 'None' then
			cmd = cmd .. ' -c "' .. color .. '"'
		end

		if flags then
			cmd = cmd .. ' ' .. flags
		end
		
		--reaper.ShowConsoleMsg(cmd)
		_ = reaper.ExecProcess(cmd, -2)

	end
end

local function split_csv(csv)
    local values = {}
    for value in csv:gmatch("[^,]+") do
        table.insert(values, value)
    end
    return values
end

local retval, retvals_csv = reaper.GetUserInputs('Make spectrogram', 3, 'directory,color,flags' .. ',extrawidth=100', '/Users/j/Documents/temp,None,,', 512)

if retval then

    local values = split_csv(retvals_csv)
    local directory = values[1]
    local color = values[2]
    local flags = values[3]

    --store_main(channels, tostring(sr), ksmps)
    main(directory, color, flags)

end

