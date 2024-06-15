require 'json'
require_relative '_path'

path = $cordelia_directory_path + '/_GEN' + '/**/*.orc'
json = $cordelia_setting_path + '/gen.json'

#GEN
gen = {}
Dir[path].each do |f|
	name = File.basename(f, '.*')
	gen[name] = f
end
File.open(json, 'w') { |f| f.puts JSON.pretty_generate(gen) }
