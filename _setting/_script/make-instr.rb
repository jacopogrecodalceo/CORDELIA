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

	elsif type == 'hybrid'
		Dir[t + '/*.orc'].each do |f|
			name = File.basename(f, '.*')

			first_lines = File.open(f).first(5)
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

			instruments[name] = {
				'type' => type,
				'path' => f,
				'required' => required_instr,
				'global_var' => File.read(f).scan(/gk#{name}_[a-z]+/).uniq + File.read(f).scan(/gi#{name}_[a-z]+/).uniq
			}
		end
			
	elsif type == 'sonvs'
		Dir[t + '/*'].each do |f|
			name = File.basename(f, '.*')

			if File.file?(f)
				instruments[name] = {
					'type' =>  'sonvs',
					'path' => ["#{f}"],
					'channels' => `soxi -c #{f}`.strip,
					'sr' => `soxi -r #{f}`.strip
				}
			elsif File.directory?(f)
				wav_inside = Dir[f + '/*.wav']
				cavia = wav_inside.first
				instruments[name] = {
					'type' =>  'sonvs',
					'path' => wav_inside,
					'channels' => `soxi -c #{cavia}`.strip,
					'sr' => `soxi -r #{cavia}`.strip
				}

			end
		end
	end
end
instruments = instruments.sort.to_h
File.open(json, 'w') { |f| f.puts JSON.pretty_generate(instruments) }
