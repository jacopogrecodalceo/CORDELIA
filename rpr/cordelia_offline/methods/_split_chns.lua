local SOX_PATH = '/opt/homebrew/bin/sox'



-- Get input file path (replace this with your actual path or use a file dialog)
local input_file = '/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/etag2.wav'
local output_dir = '/Users/j/Desktop/'

-- Extract base filename without extension
local base_name = input_file:match("(.+)%..+$"):match("([^/]+)$")

-- First detect number of channels using SoX
local info_cmd = string.format('%s --i -c "%s" 2>&1', SOX_PATH, input_file)
local info = io.popen(info_cmd)
local channels = 1

if info then
	local sox_output = info:read("*a")
    channels = tonumber(sox_output:match("(%d+)"))
    if channels and channels > 0 then
        channels = channels
    else
        print("Warning: Could not determine channel count, defaulting to 1")
        print("SoX output was:", sox_output)
    end

    info:close()
else
    print("Error: Could not get file info with SoX")
    os.exit(1)
end

print(string.format("Splitting %s (%d channels) to mono files...", base_name, channels))

-- Split each channel to separate file
for ch = 1, channels do
    local output_file = string.format('%s%s-ch%d.wav', output_dir, base_name, ch)
    local command = string.format('%s "%s" "%s" remix %d', SOX_PATH, input_file, output_file, ch)
    
    print(string.format("Processing %s...", output_file))
    local result = os.execute(command)
    
    if not result then
        print(string.format("Error processing channel %d", ch))
    end
end

print("Done! Created files:")
for ch = 1, channels do
    print(string.format("%s%s-ch%d.wav", output_dir, base_name, ch))
end

return