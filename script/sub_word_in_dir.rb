

dir = '/Users/j/Documents/PROJECTs/CORDELIA/_core/1-character'


Dir.glob(dir + '**/*') do |path|
    if not File.directory?(path)
        if File.extname(path) == '.orc' || File.extname(path) == '.csd'
            data = File.read(path) 
            filter_data = data.gsub(/\$END_INSTR/, '$INSTR_END')
            File.open(path, 'w') do |new_path|
                new_path.write(filter_data)
            end
        end
    end
end
