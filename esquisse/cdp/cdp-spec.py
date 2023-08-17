import os
import sys
import shutil
import re


# Get the current script's directory
script_dir = os.path.dirname(os.path.abspath(__file__))

print("Script directory:", script_dir)

input_file = sys.argv[1]
output_file = script_dir + '/out.wav'

# 1 separate multi-channel into mono channels
# -------------------------------------------
# 1.1 copy file inside the directory
input_copy = script_dir + '/in.wav'
shutil.copy(input_file, input_copy)
# 1.2 separate each file into mono
cmd = f'housekeep chans 2 {input_copy}'
os.system(cmd)
# 1.3 looking for files that ends with
mono_files = [filename for filename in os.listdir(script_dir) if re.search(r'_c\d+\.wav$', filename)]

