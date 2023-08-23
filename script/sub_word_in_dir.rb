

dir = '/Users/j/Documents/PROJECTs/CORDELIA/_INSTR'

Dir.glob("#{dir}/**/*") do |path|
	if !File.directory?(path)
		if File.extname(path) == '.orc' || File.extname(path) == '.csd'
			data = File.read(path)
			filter_data = data.gsub(/endin/, '')
			File.open(path, 'w') do |new_file|
				new_file.write(filter_data)
			end
		end
	end
end