require 'json'

cordelia_path = __dir__

cordelia_json_instr = cordelia_path + '_list/instr.json'

instruments = {}
Dir.glob(cordelia_path + '/_core/instr' + '/*.orc') do |f|
    name = File.basename(f, '.*')
    instruments[name] = {
        'type' => File.basename(File.dirname(f)),
        'path' => f,
        'global_var' => File.read(f).scan(/gk#{name}\w+/).uniq + File.read(f).scan(/gi#{name}\w+/).uniq
    }
end

File.open(cordelia_json_instr, 'w') { |f| f.puts JSON.pretty_generate(instruments) }
