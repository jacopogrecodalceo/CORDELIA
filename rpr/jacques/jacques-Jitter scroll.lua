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
local script_name = 'JITTER SCROLL'
load_modules(script_path)
--math.randomseed(os.time())

function jitter_scroll(item_, info, jitter_info)
    local take = reaper.GetActiveTake(item_)
    reaper.SetMediaItemTakeInfo_Value(take, "D_STARTOFFS", info.offset+useful.jitter(jitter_info.base, jitter_info.amount))
end

function main()

	-- get selected items
	local selected_items_ = items.get_selected()

	-- get input values
	local input_table = {
		{name="base", value=1/16},
		{name="amount", value=1/48},
	}
	local values = input.get(script_name, input_table)
	if not values then return end
	local jitter_info = {
		base = useful.eval(values[1]),
		amount = useful.eval(values[1]),
	}

	reaper.Undo_BeginBlock()
	reaper.PreventUIRefresh(1)

	-- get info item
	for _, item_ in pairs(selected_items_) do
		local info = item.get_info(item_)
		if not info then reaper.ShowMessageBox("Error in getting info from item", "Error", 0) return end
		-- main function
		--log(extratone_info, item_info)
		jitter_scroll(item_, info, jitter_info)
	end

	reaper.TrackList_AdjustWindows(false)
	reaper.UpdateArrange()
	reaper.PreventUIRefresh(-1)
	reaper.Undo_EndBlock(script_name, -1)

end

main()