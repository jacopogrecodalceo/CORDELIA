fx_array                 = Hash.new

fx_array["ANAL"]         = File.open('../_CORE/3-body/3-FX/_def/anal_def.txt').read
fx_array["FREQ"]         = File.open('../_CORE/3-body/3-FX/_def/freq_def.txt').read
fx_array["OP1"]          = File.open('../_CORE/3-body/3-FX/_def/op1_def.txt').read
fx_array["TIME"]         = File.open('../_CORE/3-body/3-FX/_def/time_def.txt').read
fx_array["TIME_FT"]      = File.open('../_CORE/3-body/3-FX/_def/timeft_def.txt').read
fx_array["2STRINGS"]      = File.open('../_CORE/3-body/3-FX/_def/2strings_def.txt').read

fx_init                  = File.open('../_CORE/3-body/3-FX/_FX-init.txt').read

def_fx_dir      = '../_CORE/3-body/3-FX' 
fx_full_file    = '../_CORE/3-body/3-FX/_FX-full.orc' 

#DELETE OLD .ORC
if  File.exist?(fx_full_file) then
    File.delete(fx_full_file)
    File.open(fx_full_file, 'w')
else
    File.open(fx_full_file, 'w')
end

#GENERATE INIT
fx_init.each_line do |line|
    full_orc = File.open(fx_full_file, "a")
    full_orc.write(line)
    #puts line
    rescue IOError => e
    #some error occur, dir not writable etc.
    ensure
    full_orc.close unless full_orc.nil?
end

#GENERATE FROM DEF
Dir[def_fx_dir + '/*.orc'].each do |each_fx_file|

    each_fx_name = File.basename(each_fx_file, '.orc')

    if each_fx_name.start_with?('_')==false then

        fx_array.each do |fx_type, fx_def_text|

            if File.open(each_fx_file).read.lines.first.match(/(\w+)/)[0].to_s==fx_type then

                fx_def_text.each_line do |each_fx_line|
                    begin
                        full_orc = File.open(fx_full_file, "a")
                        full_orc.write(each_fx_line.gsub("---NAME---", each_fx_name))
        
                        instr_sig = ";---INSTRUMENT---\n"
                        if each_fx_line==instr_sig then
                            each_fx_text = File.open(each_fx_file).read
                            full_orc.write(each_fx_line.gsub(";---INSTRUMENT---", each_fx_text))
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
