samp_sampdef_file      = File.open('../_CORE/3-body/5-INSTR/_sample/_sampleDEF.txt').read
samp_dirdef_file       = File.open('../_CORE/3-body/5-INSTR/_sample/_dirDEF.txt').read

samp_dir           = '../samples' 
samp_orc_dir       = '../_CORE/3-body/5-INSTR/_sample'

#DELETE ALL .ORC
Dir[samp_orc_dir + '/*.orc'].each do |file|
    File.delete(file)
end


#GENERATE FROM SAMPLES
Dir[samp_dir + '/*.wav'].each do |path|
    
    each_samp_path  = path.gsub("../../", "../")
    each_samp_name = File.basename(path, '.wav')

    samp_orc_file   = samp_orc_dir + "/" + each_samp_name + ".orc"
    
    File.open(samp_orc_file, 'w')
    
    samp_sampdef_file.each_line do |line|
        begin
            orc     = File.open(samp_orc_file, "a")
            orc.write(line.gsub("---NAME---", each_samp_name).gsub("---PATH---", '"' + each_samp_path + '"'))
            rescue IOError => e
            #some error occur, dir not writable etc.
            ensure
            orc.close unless orc.nil?
        end
    end
end


#GENERATE FROM DIR
Dir[samp_dir + '/*'].each do |dir_inside|
    if File.directory?(dir_inside)

        dir_inside_path = dir_inside.gsub("../../", "../")
        dir_inside_name = File.basename(dir_inside, '.wav')

        samp_orc_file   = samp_orc_dir + "/" + dir_inside_name + ".orc"

        File.open(samp_orc_file, 'w')
        orc     = File.open(samp_orc_file, "a")

        sonvs_array = []

        Dir[dir_inside + '/*.wav'].each do |each_dir_inside|
            
            each_dir_inside_path = dir_inside.gsub("../../", "../")
            each_dir_inside_name = File.basename(each_dir_inside, '.wav').gsub("-", "_")

            orc.write('gS' + each_dir_inside_name + "_file \t init \"" + each_dir_inside.gsub("../../", "../") + "\"\n")
            orc.write('gi' + each_dir_inside_name + "_1\t\t ftgen 0, 0, 0, 1, gS" + each_dir_inside_name + "_file, 0, 0, 1\n")
            orc.write('gi' + each_dir_inside_name + "_2\t\t ftgen 0, 0, 0, 1, gS" + each_dir_inside_name + "_file, 0, 0, 2\n")
            orc.write(";---\n")

            sonvs_array << 'gi' + each_dir_inside_name + "_1"
            sonvs_array << 'gi' + each_dir_inside_name + "_2"

        end

        sonvs_array_name = "gi" + dir_inside_name + "_sonvs"
        orc.write(sonvs_array_name + "[]\t\t\tfillarray\t") 

        sonvs_array.each do |i|
            if  sonvs_array.index(i)<sonvs_array.length-1 then
                orc.write(i + ', ')
            else
                orc.write(i)
            end
        end

        orc.write("\n") 

        samp_dirdef_file.each_line do |line|
            begin
                orc.write(line.gsub("---NAME---", dir_inside_name).gsub("---PATH---", '"' + dir_inside_path + '"').gsub("---ARRAY---", sonvs_array_name))
                rescue IOError => e
                #some error occur, dir not writable etc.
                ensure
                #orc.close unless orc.nil?
            end
        end
    end
end