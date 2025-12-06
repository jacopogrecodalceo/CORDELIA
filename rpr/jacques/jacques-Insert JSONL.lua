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
local script_name = 'Insert JSONL'
load_modules(script_path)
--math.randomseed(os.time())


local free_mode = true
local function main()
	local retval, file = input.open_file('Open JSONL')
	if not retval then return end
	if not file then useful.error('File not valid') return end

	local data = read.jsonl(file)
	if not data then useful.error('Data not valid') return end
	if #data <= 1 then useful.error('Data probably unvalid') return end
	reaper.Undo_BeginBlock()
	local new_track = track.create_new('jsonl', free_mode)
	local idx = 0
	for _, obj in ipairs(data) do
		if obj.event then
			local e = obj.event
			local item_ = item.create_emtpy(new_track, e.onset, e.duration)
			item.fill(item_, e.path, e.offset)
			if e.rms then
				reaper.SetMediaItemInfo_Value(item_, 'D_VOL', e.rms)
			end
			reaper.SetMediaItemInfo_Value(item_, 'F_FREEMODE_Y', (idx/15)%1)
			reaper.SetMediaItemInfo_Value(item_, 'F_FREEMODE_H', 1/15)
			idx = idx+1
		end
	end
	reaper.UpdateArrange()
	reaper.Undo_EndBlock(script_name, -1)

end

main()