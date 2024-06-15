
f = '/Users/j/Documents/PROJECTs/CORDELIA/_core'

macros = []

Dir.glob(f + '/**/*.orc') do |f|
    if File.basename(f).start_with?('SCALE') == false then
        macros.concat(File.read(f).scan(/\$\w+/).uniq)
    end
end

macros = macros.uniq

p macros.length