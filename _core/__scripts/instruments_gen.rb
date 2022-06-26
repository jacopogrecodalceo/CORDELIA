=begin

Dir.each_child('./__instr') do |instr|
    next if instr == '.' or instr == '..'
    puts File.basename(instr)
    # Do work on the remaining files & directories
end

Dir.glob("__instr/**/*.orc") do |instr|
    puts File.basename(instr)
  end
=end

instr       = []
instr_file  = '../00_instruments.orc'

if  File.file?(instr_file) then
    File.delete(instr_file)
    File.open(instr_file, 'w')
else
    File.open(instr_file, 'w')
end

Dir['../__instr/**/*.orc'].each do |path|
    instr_sel = File.basename(path, '.orc')
    if instr_sel.start_with?('_')==false then
        instr.push(instr_sel)
    end
end
instr   = instr.sort

begin

    orc     = File.open(instr_file, "a")
    orc.write("gSinstrs[]\t\t\tfillarray\t") 
    #open(instr_file, 'a') << "gSinstrs[]\t\t\tfillarray\t"
    instr.each do |i|
        if  instr.index(i)<instr.length-1 then
            orc.write('"' + i + '"' + ', ')
        else
            orc.write('"' + i + '"')
        end
    end

    orc.write("\n\n")
    orc.write("ginstrslen\t\t\tlenarray gSinstrs")
    orc.write("\n\n")

    instr.each do |i|
        orc.write('gS' + i + '[]' + "\t\t\tinit ginchnls")
        orc.write("\n")
    end

    orc.write("\n")
    orc.write("indx\tinit 0")
    orc.write("\n")
    orc.write("until\tindx == ginchnls do")
    orc.write("\n")

    instr.each do |i|
        orc.write("\t" + 'gS' + i + "[indx]\t\t\tsprintf\t" + '"' + i + '_%i", indx+1')
        orc.write("\n")
    end
    orc.write("\t" + "indx\t+= 1")
    orc.write("\n")
    orc.write('od')
    orc.write("\n\n")

=begin
gSaaron[]	init ginchnls
indx		init 0
until	indx == ginchnls	do
			gSaaron[indx] sprintf "aaron_%i", indx+1
			indx	+= 1
od
=end

rescue IOError => e
    #some error occur, dir not writable etc.
ensure
    orc.close unless orc.nil?
end