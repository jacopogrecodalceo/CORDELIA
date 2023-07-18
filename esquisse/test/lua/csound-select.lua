local CORDELIA_CORE = '/Users/j/Documents/PROJECTs/CORDELIA/_core'
local command = 'cd "' .. CORDELIA_CORE .. '/_server/" && python3 cordelia.py'
local csound_process = io.popen(command)

function read_csound_output(process)
    -- Check if there is any data available to read
    local ready, _, _ = select(2, process:poll(0))
    local output = ''
    if ready then
        -- Read the available data
        output = process:read("*a")
    end
    return output, ready
end

local output, ready = read_csound_output(csound_process)
if ready then
    -- Print the output
    print(output)
else
    -- Do something else
    print("No data available")
end

