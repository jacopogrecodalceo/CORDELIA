csv = {}

function csv.get(input_table)
    local keys = {}
    local values = {}
    for _, tab in ipairs(input_table) do
        table.insert(keys, tab[1])
        table.insert(values, tab[2])
    end

    local keys_csv = table.concat(keys, ',')
    local values_csv = table.concat(values, ',')

    return keys_csv, values_csv
end

function csv.split(string)
	local values = {}
	for value in string:gmatch("[^,]+") do
		table.insert(values, value)
	end
	return values
end

return csv