$gen_rev = String.new

Dir["#{__dir__}/*.orc"].each do|f|

  if (File.basename(f).to_s.match(/./).to_s != "_")                       #if name does not start with "_"
    
    orc           = File.read(f)

    ftgen_line    = orc.match(/.*(?:ftgen).*/)                            #line of ftgen

    ftgen_after   = ftgen_line.to_s.match(/.+?ftgen.+?,.+?,.+?,.\K.*/)    #everything after gen number
    ftgen_before  = ftgen_line.to_s.match(/ftgen.+?,.+?,.+?,./)           #everything before gen number w/out name

    gen_num       = ftgen_after.to_s.match(/^[0-9]/).to_s.to_i            #only the gen number
    gen_args      = ftgen_after.to_s.match(/^[0-9],.\K.*/)                #only the gen args
    gen_namerev   = ftgen_line.to_s.match(/\w+/).to_s + "r"


    #Normal reverse - numbers in couple
    #GEN05, GEN07 & GEN08
    if (gen_num == 5 || gen_num == 7 || gen_num == 8) then
      gen_argsrev = gen_args.to_s.split(/\s*,\s*/).reverse.join(", ")
      gen_sub = ftgen_after.to_s.gsub(/^[0-9],.\K.*/, gen_argsrev)

    $gen_rev << gen_namerev.to_s + "\t\t" + ftgen_before.to_s + gen_sub.to_s + "\n\n"
    
    end

  end

end

File.open(__dir__ + "/zREVs" + ".orc", "w") { |f| f.write($gen_rev) }

