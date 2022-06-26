points = [*2..32]

#add here if there is more speakers
#points.append(24)
#points.append(32)

space_csd      = '../00_space.orc'

File.open(space_csd, 'w')
orc     = File.open(space_csd, "a")

gen_name    = ['giarith', 'giline', 'girot', 'gieven', 'giodd', 'gidist']

points.each do |each_points|

    giodd       = []
    gieven      = []
    giarith     = []
    giline      = []
    girot       = []
    gidist      = []

    odd_num     = 0
    even_num    = 0

    begin
        (1..each_points).each do |i|
            if  i%2!=0 then
                giodd[odd_num]    = i
                odd_num += 1
            end

            if  i%2==0 then
                gieven[even_num]    = i
                even_num += 1
            end

            giarith[i-1] = i
        end

        gidist      = giodd + giodd

        giline      = giodd.sort_by { |i| -i } + gieven.sort_by { |i| -i }
        girot       = gieven + giodd.sort_by { |i| -i }

        giodd       = giodd + giodd.sort_by { |i| -i }
        gieven      = gieven + gieven.sort_by { |i| -i }

        orc.write("\n;---\t" + each_points.to_s + "\n\n")
        gen_name.each do |value|
            orc.write(value.to_s + each_points.to_s + "\t\t\tftgen\t" + '0, 0, ' + eval(value).length.to_s + ', -2, ' + eval(value).join(", "))
            orc.write("\n")
        end
        orc.write("\n;---\n\n")
    end
end

#make girot, giline, .. with the max ginchnls
orc.write("\n;---\tSTANDARD\n\n")
gen_name.each do |value|
    orc.write(value.to_s + "\t\t= " + value.to_s + "4")
    orc.write("\n")
end
orc.write("\n;---\n\n")