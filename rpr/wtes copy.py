import os

output_tempdir = '/Users/j/Documents/PROJECTs/_temp'
input_file_wav = '/Users/j/Desktop/dp-glued.wav'
basename = os.path.splitext(os.path.basename(input_file_wav))[0]

for f in os.listdir(output_tempdir):
    if f.endswith('.ats') and basename in f:
        print(f)
        #os.remove(f)
