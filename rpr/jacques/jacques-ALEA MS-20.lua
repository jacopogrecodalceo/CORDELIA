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
local script_name = 'ALEA MS-20'
load_modules(script_path)

local fx_name = "Saike MS-20 filter emulation"
local param_index, param
local function main()

	local selected_items_ = items.get_selected()
	if #selected_items_ <= 1 then reaper.ShowMessageBox("No item selected", "Error", 0) return end

	reaper.Undo_BeginBlock()
	reaper.PreventUIRefresh(1)

	for _, item_ in pairs(selected_items_) do
		local take = reaper.GetActiveTake(item_)
		local fx_index = reaper.TakeFX_AddByName(take, fx_name, 1)

		-- drive
		param_index = 0
		param = useful.random(21, 24)
		reaper.TakeFX_SetParam(take, fx_index, param_index, param)

		-- filter type
		param_index = 2
		param = 1
		reaper.TakeFX_SetParam(take, fx_index, param_index, param)

		-- non-linearity
		param_index = 4
		param = 0
		reaper.TakeFX_SetParam(take, fx_index, param_index, param)

		param_index = 5
		param = 0
		reaper.TakeFX_SetParam(take, fx_index, param_index, param)

		-- cutoff
		param_index = 6
		param = useful.random(1/64, 1)
		reaper.TakeFX_SetParam(take, fx_index, param_index, param)

		-- resonance
		param_index = 7
		param = useful.random(.85, .95)
		reaper.TakeFX_SetParam(take, fx_index, param_index, param)

		-- oversampling
		param_index = 8
		param = 2
		reaper.TakeFX_SetParam(take, fx_index, param_index, param)

	end

	reaper.TrackList_AdjustWindows(false)
	reaper.UpdateArrange()
	reaper.PreventUIRefresh(-1)
	reaper.Undo_EndBlock(script_name, -1)

end

main()