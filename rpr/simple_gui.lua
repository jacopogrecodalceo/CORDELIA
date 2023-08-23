local ctx = reaper.ImGui_CreateContext('My script')

tables = {}

local FLT_MIN, FLT_MAX = reaper.ImGui_NumericLimits_Float()
local file_path = '/Users/j/Documents/PROJECTs/CORDELIA/rpr/cordelia_instruments/ATS/cheby-orphans-even.orc'


function log(string)
	reaper.ShowConsoleMsg(string .. '\n')
end


function flat_table(inputTable)
    local flattenedTable = {}

    for _, value in ipairs(inputTable) do
        if type(value) == "table" then
            for _, nestedValue in ipairs(value) do
                table.insert(flattenedTable, nestedValue)
            end
        else
            table.insert(flattenedTable, value)
        end
    end

    return flattenedTable
end

function read_orc(file_path)
	local csmain = {}
	for line in io.lines(file_path) do

		local cstab = {}
		for i = 1, 3 do
			cstab[i] = ''
		end
		
		if line:match('^%S') then
			local words = {}
			local first = ''
			for w in line:gmatch('%S+') do
				table.insert(words, w)
				first = first .. w
				if w:sub(-1) ~= ',' then
					break
				end
			end
			cstab[1] = first
			local opcode_index = line:find(words[#words]) or 0
			opcode_index = opcode_index + #words[#words]
			
			local opcode_line = line:sub(opcode_index + 1):gmatch('%S+')
			local opcode_word = opcode_line() or ''
			cstab[2] = opcode_word
			
			local last_index = line:find(opcode_word, opcode_index + 1) or 0
			last_index = last_index + #opcode_word
			cstab[3] = line:sub(last_index + 1):match('^%s*(.-)%s*$')
			
			table.insert(csmain, cstab)
		else
			local words = {}
			for w in line:gmatch('%S+') do
				table.insert(words, w)
			end
			if #words > 0 then
				cstab[2] = words[1]
				local last_index = line:find(words[1]) or 0
				last_index = last_index + #words[1]
				cstab[3] = line:sub(last_index + 1):match('^%s*(.-)%s*$')
				table.insert(csmain, cstab)
			else
				table.insert(csmain, cstab)
			end
		end
	end

	return csmain

end

local num_rows = 0
local num_column = 4
if not tables.padding then
	tables.padding = {
	flags1 = reaper.ImGui_TableFlags_BordersV(),
	show_headers = false,

	flags2 = reaper.ImGui_TableFlags_Borders() | reaper.ImGui_TableFlags_RowBg(),
	cell_padding = { 0.0, 0.0 },
	show_widget_frame_bg = true,
	text_bufs = {}, -- Mini text storage for 3x5 cells
	}

	local table_3 = flat_table(read_orc(file_path))
	num_rows = #table_3
	
	for i = 1, num_rows do
		tables.padding.text_bufs[i] = table_3[i]
	end
end

function make_table()

	if reaper.ImGui_BeginTable(ctx, 'table_padding_2', num_column) then

		for cell = 1, num_rows do

			reaper.ImGui_TableNextColumn(ctx)
			reaper.ImGui_SetNextItemWidth(ctx, -FLT_MIN)


			local is_first_column = ((cell-1) % num_column) == 0

			if is_first_column then
				reaper.ImGui_Checkbox(ctx, '')
			else

				reaper.ImGui_PushID(ctx, cell)
				local content = tables.padding.text_bufs[cell]
				if is_first_column and content == '' then
					do end
				else
					--rv, tables.padding.text_bufs[cell] = reaper.ImGui_InputText(ctx, '##cell', content)
					if string.sub(content, 1, 1) == 'i' then
						reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_Text(), 0xFF6666FF)
						rv, tables.padding.text_bufs[cell] = reaper.ImGui_InputText(ctx, '##cell', content, reaper.ImGui_InputTextFlags_EnterReturnsTrue())
						if rv then
							log('enter')
						end
						reaper.ImGui_PopStyleColor(ctx)
					else
						rv, tables.padding.text_bufs[cell] = reaper.ImGui_InputText(ctx, '##cell', content, reaper.ImGui_InputTextFlags_EnterReturnsTrue())
						if rv then
							log('enter')
						end
					end
				end
				reaper.ImGui_PopID(ctx)
			end
		end

		reaper.ImGui_EndTable(ctx)

	end

end

function loop()
	local visible, open = reaper.ImGui_Begin(ctx, 'My window', true)
	
	if visible then
		make_table()
		reaper.ImGui_End(ctx)
	end

	if open then
		reaper.defer(loop)
	end
end

reaper.defer(loop)