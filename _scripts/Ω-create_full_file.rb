list_path = '../_CORE/livecode-include.csd'
list = File.open(list_path).map(&:chomp)

destination_path = '../_CORE/livecode-full.csd'

if  File.file?(destination_path) then
    File.delete(destination_path)
    File.open(destination_path, 'w')
else
    File.open(destination_path, 'w')
end

list.each do |path_list_line|

    path_list_line = path_list_line.gsub('#include "', '')
    path_list_line = path_list_line.gsub('"', '')
    #path_list_line = path_list_line[1..-1]
    #puts path_list_line

    File.readlines(path_list_line).each do |for_each_path_line|
        File.write(destination_path, for_each_path_line, File.size(destination_path), mode: 'a')
    end

    File.write(destination_path, "\n\n\n;--- ||| --- ||| ---\n\n", File.size(destination_path), mode: 'a')

end