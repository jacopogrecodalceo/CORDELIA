

dir = '/Users/j/Documents/PROJECTs/CORDELIAv4/_core/4-clothes/INSTR/instr'


Dir.glob(dir + '**/*') do |path|
    if not File.directory?(path)
        if File.extname(path) == '.orc' || File.extname(path) == '.csd'
            data = File.read(path) 
            filter_data = data.gsub(/\$end_instr/, '$END_INSTR')
            File.open(path, 'w') do |new_path|
                new_path.write(filter_data)
            end
        end
    end
end
