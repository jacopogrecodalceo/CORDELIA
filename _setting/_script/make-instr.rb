require 'json'
require_relative '_path'

path = $cordelia_directory_path + '/_INSTR' + '/*'
json = $cordelia_setting_path + '/instr.json'

instruments = {}
Dir[path].each do |t|

	type = File.basename(t)

	if type == 'instr'
		Dir[t + '/*.orc'].each do |f|
			name = File.basename(f, '.*')
			instruments[name] = {
				'type' => type,
				'path' => f,
				'global_var' => File.read(f).scan(/gk#{name}_[a-z]+/).uniq + File.read(f).scan(/gi#{name}_[a-z]+/).uniq
			}
		end
	elsif type == 'sonvs'
		Dir[t + '/*'].each do |f|

			name = File.basename(f, '.*')

			if File.file?(f)
				instruments[name] = {
					'type' =>  'sonvs',
					'path' => f,
					'channels' => `soxi -c #{f}`.strip,
					'sr' => `soxi -r #{f}`.strip
				}
			else
				instruments[name] = {
					'type' =>  'dir',
					'path' => f
				}
			end
		end
	end
end
instruments = instruments.sort.to_h
File.open(json, 'w') { |f| f.puts JSON.pretty_generate(instruments) }
