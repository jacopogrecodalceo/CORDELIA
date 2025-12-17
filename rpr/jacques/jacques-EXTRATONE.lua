function load_modules(dir)
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

local script_path = debug.getinfo(1,'S').source:sub(2):match("(.*/)")
local script_name = 'EXTRATONE MAKER'
load_modules(script_path)
--math.randomseed(os.time())

local function extratone_maker(extratone_info, item_info)
    for i = 0, extratone_info.divisions - 1 do
		local item_ = item.create_emtpy(extratone_info.track, item_info.onset+extratone_info.duration*i, extratone_info.duration, true)
		item.fill(item_, item_info.path, item_info.offset+useful.jitter(extratone_info.jitter, extratone_info.jitter/2))
	end
end

local function log(extratone_info, item_info)
	for k, v in pairs(extratone_info) do
		reaper.ShowConsoleMsg(k .. " = " .. tostring(v) .. "\n")
	end
	for k, v in pairs(item_info) do
		reaper.ShowConsoleMsg(k .. " = " .. tostring(v) .. "\n")
	end
end

local input_table = {
	{name="divisions", value=24},
	{name="jitter", value=1/48},
	{name="new track?", value=1},
}

local function main()

	-- get selected items
	local selected_items_ = items.get_selected()
	if #selected_items_ == 0 or #selected_items_ > 1 then reaper.ShowMessageBox("This script requires exactly one item to be selected.", "Error", 0) return end

	-- get input values
	local values = input.get(script_name, input_table)
	if not values then return end
	local extratone_info = {
		divisions = useful.eval(values[1]),
		jitter = useful.eval(values[2]),
		is_new_track = useful.eval(values[3]),
	}

	reaper.Undo_BeginBlock()
	reaper.PreventUIRefresh(1)

	-- get info item
	local item_ = selected_items_[1]
	local item_info = item.get_info(item_)
	if not item_info then useful.error("Error in getting info from item") return end

	-- calc duration for extratone
	extratone_info.duration = item_info.duration / extratone_info.divisions
	if (extratone_info.duration < .005 * 2) and input.ask_to_continue("Extra item duration is: " .. extratone_info.duration .. "s, continue?", "Confirmation") then return end
	if extratone_info.duration >= item_info.duration then useful.error("Division duration is >= item's") end
	-- create new track
	if extratone_info.is_new_track == 1 then
		extratone_info.track = track.create_new_under_item(item_)
	else
		extratone_info.track = track.get_track_under_item(item_)
	end
	track.set_name(extratone_info.track, "XTRTN-" .. extratone_info.divisions .. '-' .. string.format("%.2f", extratone_info.jitter) .. '-' .. path.get_file_name(item_info.path))

	-- main function
	--log(extratone_info, item_info)
	extratone_maker(extratone_info, item_info)

	reaper.TrackList_AdjustWindows(false)
	reaper.UpdateArrange()
	reaper.PreventUIRefresh(-1)
	reaper.Undo_EndBlock(script_name, -1)

end

main()