name = '/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/hybrid/bebois.orc'

first_lines = File.open(name).first(5)
keyword = ';REQUIRE'

required_instr = []

first_lines.each do |l|
	if l.start_with?(keyword)
		line = l.gsub(keyword, '').strip
		if line.include?(',')
			required_instr = line.split(',')
		else
			required_instr << line
		end
	end
end

p required_instr