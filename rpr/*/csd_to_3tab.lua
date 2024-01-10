local file_path = '/Users/j/Documents/PROJECTs/CORDELIA/rpr/cordelia_instruments/ATS/cheby-seno-full.orc'

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
			cstab[i] = '---'
		end
		
		if line:match('^%w+') then
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
			cstab[3] = line:sub(last_index + 1):match('^%s*(.-)%s*$') or '---'
			
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

				cstab[3] = line:sub(last_index + 1):match('^%s*(.-)%s*$') or '---'
				table.insert(csmain, cstab)
			else
				table.insert(csmain, cstab)
			end
		end
	end

	return csmain

end

local table_3 = read_orc(file_path)
local num_rows = #table_3

for i = 1, num_rows do
	print(table_3[i][3])
end