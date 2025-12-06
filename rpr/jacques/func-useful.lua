useful = {}

function useful.jitter(base_value, jitter_amount)
    return base_value + (math.random() * 2 - 1) * jitter_amount
end

function useful.eval(str)
    local f, err = load("return " .. str)
    if not f then
        return nil, err
    end
    local success, result = pcall(f)
    if success then
        return result
    else
        return nil, result
    end
end

-- returns a random float between min and max
function useful.random(min, max)
    return min + math.random() * (max - min)
end


function useful.error(string)
    reaper.ShowMessageBox(string, "Error", 0)
end

return useful