function get_csv(input_table)
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

function split_csv(csv)
	local values = {}
	for value in csv:gmatch("[^,]+") do
		table.insert(values, value)
	end
	return values
end