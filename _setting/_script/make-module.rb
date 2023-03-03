require 'json'
require_relative '_path'

path = $cordelia_directory_path + '/_MOD' + '/*'
json = $cordelia_setting_path + '/module.json'

mod_file = $cordelia_directory_path + '/_core/3-body/3-MOD.orc'

mod = File.open(mod_file, 'w')

modules = {}
Dir[path].each do |f|
	name = File.basename(f, '.*')
	text = File.read(f)
	num = text.scan(/PARAM_\d+/i)

	modules[name] = {}
	modules[name]['core'] = ''


	is_core = false
	is_opcode = false
	File.foreach(f) do |line|

		if line.start_with?(';CORE')
			is_core = true
			is_opcode = false
		elsif line.start_with?(';OPCODE')
			is_opcode = true
			is_core = false
		end

		if is_core
			modules[name]['core'] += line
		end
		
		if is_opcode
			mod.write(line)
		end

	end
	

	modules[name]['path'] = f
	modules[name]['how_many_p'] = num.uniq.size

end
mod.close()
modules = modules.sort.to_h
File.open(json, 'w') { |f| f.puts JSON.pretty_generate(modules) }
