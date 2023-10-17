require 'json'
require_relative '_path'

include_dir = [
	'character',
	'head',
	'body'
]
include_path = $cordelia_directory_path + '/_core/include.orc'
include_file = File.open(include_path, 'w')

Dir[$cordelia_directory_path + '/**/*.orc'].each do |f|
	include_dir.each do |i|
		#p Pathname.new(f).each_filename.to_a
		if Pathname.new(f).each_filename.to_a.find{ |e| /#{i}/ =~ e }
			include_file.write("#include \"#{f}\"\n")
		end
	end
end
include_file.close()