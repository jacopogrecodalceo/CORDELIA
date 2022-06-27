
dir      = '../../../_core/'
answer    = ARGV[0]

all_files = []

Dir.glob(dir + '**/*') do |f|
    if not File.directory?(f)
        if File.extname(f) == ".orc" || File.extname(f) == ".csd"
            File.open(f).read.each_line do |line|
                if line.match( /\b#{answer}\b/i )
                    #puts "#{m[0]} was found in " + f
                    all_files.append(f)
                end
            end
        end
    end
end


all_files = all_files.uniq

all_files.each do |a|
    puts a
end