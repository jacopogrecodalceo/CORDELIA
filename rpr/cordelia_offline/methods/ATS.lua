
-- get current date

--
REMOVE_FILEs = true

--get the input audio file

--get the orc file

--get the output

--get basename of input audio file

--fix the temp directory of the output
--generate a log file


-- for each .orc file at the end there will be a score section in order to directly control the score
-- lua_score = extract the lua score part from the .orc file
-- evaluate lua score

-- from the wav file genereate as many mono files as the number of channels

-- for each mono file generate an ats file with a simple command ''/usr/local/bin/atsa', input_file, output_file'

-- retrive the ats files

-- generate the score

-- set csound fixed flags
--[[

cs.setOption(f'-o{output_file_wav}')
cs.setOption(f'--format=24bit')
cs.setOption(f'--0dbfs=1')

]]

-- wait for the file to finish

--remove the files

-- create a file that its finished like 'output_file_wav + '--finished'
