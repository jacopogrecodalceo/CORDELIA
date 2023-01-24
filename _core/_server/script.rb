require 'json'
require 'Pathname'

cordelia_path = File.expand_path('../..', Dir.pwd)


#include
include_dir = [
	'character',
	'head',
	'body'
]
include_path = cordelia_path + '/_core/include.orc'
include_file = File.open(include_path, 'w')
Dir[cordelia_path + '/**/*.orc'].each do |f|
	include_dir.each do |i|
		#p Pathname.new(f).each_filename.to_a
		if Pathname.new(f).each_filename.to_a.find{ |e| /#{i}/ =~ e }
			include_file.write("#include \"#{f}\"\n")
		end
	end
end
include_file.close()



#INSTR
cordelia_json_instr_path = cordelia_path + '/_list/instr.json'
instruments = {}
Dir[cordelia_path + '/_core/**/*.orc'].each do |f|
	if Pathname.new(f).each_filename.to_a.include?('INSTR')
		name = File.basename(f, '.*')
		instruments[name] = {
			'type' => File.basename(File.dirname(f)),
			'path' => f,
			'global_var' => File.read(f).scan(/gk#{name}_[a-z]+/).uniq + File.read(f).scan(/gi#{name}_[a-z]+/).uniq
		}
	end
end
File.open(cordelia_json_instr_path, 'w') { |f| f.puts JSON.pretty_generate(instruments) }


#SCALA
cordelia_json_scala_path = cordelia_path + '/_list/scala.json'
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
Dir[cordelia_path + '/_core/4-clothes/SCALA/_current/**/*.scl'].each do |f|
	name = File.basename(f, '.*')

	if not name.start_with('_'):

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
			string = "gi#{name} ftgen 0, 0, 0, -2, #{degrees}, #{interval}, #{basefreq}, #{basekey}, #{base_val}, #{tuning_value.join(', ')}\n"
			scala[name] = {
				'path' => f,
				'degrees' => degrees,
				'ftgen' => string
			}
		end
end
File.open(cordelia_json_scala_path, 'w') { |f| f.puts JSON.pretty_generate(scala) }


#GEN
cordelia_json_gen_path = cordelia_path + '/_list/gen.json'
gen = {}
Dir[cordelia_path + '/_core/**/*.orc'].each do |f|
	if Pathname.new(f).each_filename.to_a.include?('ENV')
		name = File.basename(f, '.*')
		gen[name] = f
	end
end
File.open(cordelia_json_gen_path, 'w') { |f| f.puts JSON.pretty_generate(gen) }


#MACROs
cordelia_json_instr_path = cordelia_path + '/_list/macro.json'
macros = []
Dir[cordelia_path + '/_core/**/*.orc'].each do |f|
	begin
		macros += File.read(f).scan(/\$(\w+)/)
	rescue
		p "Error #{f}"
	end
end
macros = macros.uniq
File.open(cordelia_json_instr_path, 'w') { |f| f.puts JSON.pretty_generate(macros.flatten) }


#gi
cordelia_json_gi_path = cordelia_path + '/_list/gi.json'
gi = []
Dir[cordelia_path + '/_core/**/*.orc'].each do |f|
	begin
		gi += File.read(f).scan(/\Wgi(\w+)\W/)
	rescue
		p "Error #{f}"
	end
end
gi = gi.uniq
File.open(cordelia_json_gi_path, 'w') { |f| f.puts JSON.pretty_generate(gi.flatten) }


#gk
cordelia_json_gk_path = cordelia_path + '/_list/gk.json'
gk = []
Dir[cordelia_path + '/_core/**/*.orc'].each do |f|
	begin
		gk += File.read(f).scan(/\Wgk(\w+)\W/)
	rescue
		p "Error #{f}"
	end
end
gk = gk.uniq
File.open(cordelia_json_gk_path, 'w') { |f| f.puts JSON.pretty_generate(gk.flatten) }
