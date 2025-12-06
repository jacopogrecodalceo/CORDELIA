regex = {}

function replace_dots(str)
    local values = {}
    for value in str:gmatch("[^.]+") do
        local num = tonumber(value)
        if num then
            table.insert(values, math.floor(num))
        end
    end
    return values
end

return regex
