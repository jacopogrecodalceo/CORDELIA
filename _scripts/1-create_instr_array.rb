require_relative __dir__ + "/_path.rb"

instr_dir_out     = $cordelia_head + 'INSTR.orc'
instr_array         = []

if  File.file?(instr_dir_out) then
    File.delete(instr_dir_out)
    File.open(instr_dir_out, 'w')
else
    File.open(instr_dir_out, 'w')
end

Dir[$cordelia_instr + '**/*.orc'].each do |path|
    instr_name = File.basename(path, '.orc')
    if instr_name.start_with?('_') == false then
        instr_array.push(instr_name)
    end
end

instr_array         = instr_array.sort

begin

    orc     = File.open(instr_dir_out, "a")
    orc.write("gSinstrs[]\t\t\tfillarray\t") 

    instr_array.each do |i|
        if  instr_array.index(i)<instr_array.length-1 then
            orc.write('"' + i + '"' + ', ')
        else
            orc.write('"' + i + '"')
        end
    end

    orc.write("\n\n")
    orc.write("ginstrslen\t\t\tlenarray gSinstrs")
    orc.write("\n\n")

    instr_array.each do |i|
        orc.write('gS' + i + '[]' + "\t\t\tinit ginchnls")
        orc.write("\n")
    end

    orc.write("\n")
    orc.write("indx\tinit 0")
    orc.write("\n")
    orc.write("until\tindx == ginchnls do")
    orc.write("\n")

    instr_array.each do |i|
        orc.write("\t" + 'gS' + i + "[indx]\t\t\tsprintf\t" + '"' + i + '_%i", indx+1')
        orc.write("\n")
    end
    
    orc.write("\t" + "indx\t+= 1")
    orc.write("\n")
    orc.write('od')
    orc.write("\n\n")

    rescue IOError => e
        #some error occur, dir not writable etc.
    ensure
        orc.close unless orc.nil?
        
end