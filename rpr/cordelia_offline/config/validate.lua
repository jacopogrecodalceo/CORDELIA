
local validate = {}

function validate.commands(commands)
    for name, path in pairs(commands) do
        local command = string.format('test -x %q', path)
        local result = os.execute(command)
        if not result then
            print(string.format("Error: Command %s not found at path %s", name, path))
            os.exit(1)
        end
    end
end

function validate.dirs(dirs)
    for name, dir_path in pairs(dirs) do
        local file = io.open(dir_path, "r")
        if not file then
            print(string.format("Error: Directory %s (%s) does not exist or is not accessible.", name, dir_path))
            os.exit(1)
        end
        file:close()
    end
end

function validate.cordelia(cordelia_dir)
    local file = io.open(cordelia_dir, "r")
    if not file then
        print(string.format("Error: Cordelia directory is wrong: %s (%s) does not exist or is not accessible.", name, file_path))
        os.exit(1)
    end
    file:close()
end

function validate.files(files)
    for name, file_path in pairs(files) do
        local file = io.open(file_path, "r")
        if not file then
            print(string.format("Error: File %s (%s) does not exist or is not accessible.", name, file_path))
            os.exit(1)
        end
        file:close()
    end
end

return validate