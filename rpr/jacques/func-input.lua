input = {}

local script_path = debug.getinfo(1,'S').source:sub(2):match("(.*/)")
csv = dofile(script_path .. 'func-csv.lua')

function input.get(title, input_table)
    local captions = {}
    local defaults = {}
    for _, entry in ipairs(input_table) do
        table.insert(captions, entry.name)
        table.insert(defaults, tostring(entry.value))
    end
    
    local num_inputs = #captions
    -- string title, integer num_inputs, string captions_csv, string retvals_csv)
    local retval, retvals_csv = reaper.GetUserInputs(title, num_inputs, table.concat(captions, ','), table.concat(defaults, ','), 512)
    if retval then
        local values = csv.split(retvals_csv)
        return values
    end
    return nil
end

function input.ask_to_continue(string, title)
    local retval = reaper.ShowMessageBox(string, title, 4)
    -- 4 = Yes/No, returns 6 for Yes, 7 for No
    if retval == 6 then
        return true
    else
        return false
    end
end

function input.open_file(title, init_dir, allow_multiple)
	--local retval, folder = reaper.JS_Dialog_BrowseForFile(, )
    init_dir = init_dir and init_dir or "/Users/j/Documents/PROJECTs"
    allow_multiple = allow_multiple and allow_multiple or false
    local retval, file = reaper.JS_Dialog_BrowseForOpenFiles(title, init_dir, "", "\0*.jsonl", allow_multiple)
    if retval <= 0 then
        return false
    else
        return retval, file
    end
end

return input