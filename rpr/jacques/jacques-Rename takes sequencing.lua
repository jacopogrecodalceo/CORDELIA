--[[
360212
simply rename some takes or items by a string
if they are more then 2 add a sequence by jacques' rules
]]

-- -------------------------------------------------------------------------- --
--                                LOAD MODULEs                                --
-- -------------------------------------------------------------------------- --

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
local script_name = 'Rename takes sequencing'
load_modules(script_path)

-- -------------------------------------------------------------------------- --
--                                    CORE                                    --
-- -------------------------------------------------------------------------- --
PATH = "/Users/j/Documents/PROJECTs/♥︎-docu/_COMPOSERs/shakespeare/king_lear.txt"

local function get_alea_phrase_from_path()
	math.randomseed(os.time())
	local chosen_line = nil
	local valid_count = 0

	for line in io.lines(PATH) do
		if line ~= "" then
			local words = {}
			for w in line:gmatch("%w+") do
				words[#words + 1] = w
				if #words >= 3 then break end
			end

			if #words >= 3 then
				valid_count = valid_count + 1
				if math.random(valid_count) == 1 then
					chosen_line = line
				end
			end
		end
	end

	if not chosen_line then return nil end

	local words = {}
	for w in chosen_line:gmatch("%w+") do
		words[#words + 1] = w
	end

	local n = #words
	if math.random(4)>2 then
		return table.concat({
			words[math.random(n)],
			words[math.random(n)],
			words[math.random(n)]
		}, " ")
	else
		return chosen_line
	end
end


local function main()
	local shakespearean = get_alea_phrase_from_path()
	local input_table = {
		 {name="RENAME:,extrawidth=64", value=shakespearean},
	}
	
	local values = input.get(script_name, input_table)
	 if not values then return end
	 local name = values[1]
	 name = name:gsub("%s", "_")

	 --reaper.ShowConsoleMsg(name)
	local selected_items_ = items.get_selected()

	reaper.Undo_BeginBlock()
	reaper.PreventUIRefresh(1)
	if #selected_items_ == 1 then
		local take = reaper.GetActiveTake(selected_items_[1])
		if take then reaper.GetSetMediaItemTakeInfo_String(take, "P_NAME", name, true) end
	else
		local count = #selected_items_
		local pad
		if count < 100 then
			pad = 2
		elseif count < 1000 then
			pad = 3
		else
			pad = 4
		end

		for index, item_ in ipairs(selected_items_) do
			local take = reaper.GetActiveTake(item_)
			if take then
					local index_str = string.format("%0"..pad.."d", index)
					reaper.GetSetMediaItemTakeInfo_String(
						take,
						"P_NAME",
						string.format("%s-%s", name, index_str),
						true
					)
			end
		end
	end

	reaper.TrackList_AdjustWindows(false)
	reaper.UpdateArrange()
	reaper.PreventUIRefresh(-1)
	reaper.Undo_EndBlock(script_name, -1)

end

main()