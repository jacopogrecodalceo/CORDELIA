opcode_array                 = Hash.new

opcode_array["ANAL"]         = File.open('../__fx/_fx-anal_def.txt').read
opcode_array["FREQ"]         = File.open('../__fx/_fx-freq_def.txt').read
opcode_array["OP1"]          = File.open('../__fx/_fx-op1_def.txt').read
opcode_array["TIME"]         = File.open('../__fx/_fx-time_def.txt').read
opcode_array["TIME_FT"]      = File.open('../__fx/_fx-timeft_def.txt').read
opcode_array["2STRINGS"]      = File.open('../__fx/_fx-2strings_def.txt').read

opcode_init                  = File.open('../__fx/_init.txt').read

def_opcode_dir      = '../__fx' 
opcode_full_file    = '../__others/fx.orc' 

#DELETE OLD .ORC
if  File.exist?(opcode_full_file) then
    File.delete(opcode_full_file)
    File.open(opcode_full_file, 'w')
else
    File.open(opcode_full_file, 'w')
end

#GENERATE INIT
opcode_init.each_line do |line|
    full_orc = File.open(opcode_full_file, "a")
    full_orc.write(line)
    #puts line
    rescue IOError => e
    #some error occur, dir not writable etc.
    ensure
    full_orc.close unless full_orc.nil?
end

#GENERATE FROM DEF
Dir[def_opcode_dir + '/*.orc'].each do |each_opcode_file|

    each_opcode_name = File.basename(each_opcode_file, '.orc')

    if each_opcode_name.start_with?('_')==false then

        opcode_array.each do |opcode_type, opcode_def_text|

            if File.open(each_opcode_file).read.lines.first.match(/(\w+)/)[0].to_s==opcode_type then

                opcode_def_text.each_line do |each_opcode_line|
                    begin
                        full_orc = File.open(opcode_full_file, "a")
                        full_orc.write(each_opcode_line.gsub("---NAME---", each_opcode_name))
        
                        instr_sig = ";---INSTRUMENT---\n"
                        if each_opcode_line==instr_sig then
                            each_opcode_text = File.open(each_opcode_file).read
                            full_orc.write(each_opcode_line.gsub(";---INSTRUMENT---", each_opcode_text))
                        end
        
                        rescue IOError => e
                        #some error occur, dir not writable etc.
                        ensure
                        full_orc.close unless full_orc.nil?
                    end
                end
            end
        end
    end

end
