require_relative __dir__ + "/_path.rb"

my_dir        = $cordelia_dir + '/_CORE/2-head/GEN'

Dir.glob(my_dir + '/*').each do |each_dir|
    if File.directory?(each_dir)

        wav_file = each_dir + '/_wav.orc'
        wav_write = File.open(wav_file, "w")

        Dir.glob(each_dir + '/**/*.wav').each do |f|
            
            wav_path    = f.gsub("../", "")
            wav_name    = File.basename(f, '.wav')    
            wav_write   = File.open(wav_file, "a")
        
            line        = "gi#{wav_name}\t\t\tftgen 0, 0, 0, 1, \"#{wav_path}\", 0, 0, 1\n"
            wav_write.write(line)
        end

        wav_write.close

    end
end

