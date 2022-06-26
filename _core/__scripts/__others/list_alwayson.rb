dir      = '/Users/j/Documents/PROJECTs/IDRA/_core/'

filter = []

Dir.glob(dir + '**/*') do |f|
    if not File.directory?(f)
        if File.extname(f) == ".orc" || File.extname(f) == ".csd"
            File.open(f).read.each_line do |line|
                if line.match( /\b#{"alwayson"}\b/i ) || line.match( /\b#{"schedule"}\b/i )
                  re = /\((.+)\)/
                  line.match(re) do |res|
                    filter.append(res.to_s)
                  end
                end
            end
        end
    end
end

list_txt = '/Users/j/Documents/PROJECTs/IDRA/_list_alwayson.txt'
list = File.open(list_txt, "w")

filter = filter.uniq
filter.each do |a|
  if a.match(/[a-z]/)
    list.write("turnoff(nstrnum" + a + ")\n")
  else
    list.write("turnoff" + a + "\n")
  end
end
list.close unless list.nil?
