#wav_file       = '../__gen/giwav.orc'
#wav_dir        = '../__gen/__wav/'

wav_file       = '/Users/j/Documents/PROJECTs/IDRA/_core/__gen/giwav.orc'
wav_dir        = '/Users/j/Documents/PROJECTs/IDRA/_core/__gen/__wav/'

wav_write = File.open(wav_file, "w")

Dir[wav_dir + '*.wav'].each do |f|

    p f
    wav_path    = f.gsub("../", "")
    wav_name    = File.basename(f, '.wav')    
    wav_write   = File.open(wav_file, "a")

    line        = "gi#{wav_name}\tftgen 0, 0, 0, 1, \"#{wav_path}\", 0, 0, 1\n"
    wav_write.write(line)

end

wav_write.close