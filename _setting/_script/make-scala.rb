require 'json'
require_relative '_path'

path = $cordelia_directory_path + '/_SCALA/_current/**/*.scl'
json = $cordelia_setting_path + '/scala.json'

scala = {}
replacements = {
    ' ' => '_',
    '#' => 'dies',
    '-' => '_',
    '+' => '_',
    '(' => '_',
    ')' => '_',
    '[' => '_',
    ']' => '_'
}
Dir[path].each do |f|
	name = File.basename(f, '.*')

	if not name.start_with?('_')

		f_open = File.open(f).read
		index_line = 0
		lines = []
		f_open.each_line do |line|
			#avoid comment 
			if not line.lstrip.start_with?('!')
				lines[index_line] = line.lstrip
				index_line += 1
			end
		end

		#first line is description
		if lines[0] != ''
			description = lines[0]
		end

		#second line is degrees
		degrees = lines[1][/(.*?)($|\s.*)/, 1]

		basefreq = 'A4'
		basekey = '69' #'ntom("4A")'

		tuning_value = []
		add_me = true
		lines[2..-1].each do |value|

			value = value[/(.*?)($|\s.*)/, 1]

			if value.include?('.')
				res = 2 ** (value.to_f/1200)
			else
				res = value
				if res[/\d+\/(\d+)/, 1].to_i > 10 ** 10
					p 'Csound cannot read this'
					add_me = false
				end
			end
			# p res
			tuning_value << res.to_s
		end

		interval = tuning_value.last

		if degrees.to_i != tuning_value.length
			p 'WARNING --- degrees are different from the tuning values'
		end

		base_val = '1'

		if add_me
			ftgen_string = "gi#{name} ftgen 0, 0, 0, -2, #{degrees}, #{interval}, #{basefreq}, #{basekey}, #{base_val}, #{tuning_value.join(', ')}"
			#f_string = "gi#{name} #{degrees} -2 #{interval} #{basefreq} #{basekey} #{base_val} #{tuning_value.join(' ')}"
			scala[name] = {
				'path' => f,
				'degrees' => degrees,
				'ftgen' => ftgen_string
			}
		end
	end
end
File.open(json, 'w') { |f| f.puts JSON.pretty_generate(scala) }


