    local CORDELIA_CORE = '/Users/j/Documents/PROJECTs/CORDELIA/_core'
    local command = 'cd "' .. CORDELIA_CORE .. '/_server/" && python3 cordelia.py'
    local csound_process = io.popen(command)

    -- Load the posix library
    local posix = require("posix")

    -- Create the anonymous pipe
    local r, w = posix.pipe()

    -- Create the child process
    local pid = posix.fork()

    if pid == 0 then
    -- Child process: redirect stdout to the write end of the pipe
    posix.dup2(w, posix.fileno(io.stdout))

    -- Replace the child process with the cordelia.py script
    posix.exec("/usr/bin/python3", {"/Users/j/Documents/PROJECTs/CORDELIA/_core/_server/cordelia.py"})
    else
    -- Parent process: close the write end of the pipe
    posix.close(w)

    -- Read the output from the read end of the pipe
    local output = ""
    while true do
    -- Wait for the pipe to become readable
    local ready, _, _ = posix.select({r}, nil, nil)
    if ready then
        -- Read the available data
        local data = posix.read(r, 4096)
        if data then
        output = output .. data
        else
        -- End of file: the child process has exited
        break
        end
    end
    end

    -- Print the output
    print(output)
    end
