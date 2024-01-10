import sox
import os




input_file_wav = '/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/amen06.wav'

try:
    #channels = subprocess.run(f'/opt/homebrew/bin/soxi -c {input_file_wav}', shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True).stdout.strip()#sox.file_info.channels(input_file_wav)
    channels = sox.file_info.channels(input_file_wav)
        
except Exception as e:
    with open('/Users/j/Desktop/Ss1.txt', 'w') as f:
        f.write(e)
    
with open('/Users/j/Desktop/Ss1.txt', 'w') as f:
    f.write(str(channels))
