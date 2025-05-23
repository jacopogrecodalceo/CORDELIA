import os
import logging
import soundfile as sf
import numpy as np

def create_mono_files(input_file_wav, basename, output_dir):

    data, sample_rate = sf.read(input_file_wav)  # shape: (samples, channels)
    if len(data.shape) == 1:
        data = data[:, np.newaxis]  # ensure 2D

    channels = data.shape[1]
    mono_files = []

    for i in range(channels):
        output_file = os.path.join(output_dir, f'{basename}-{i+1}ch.wav')
        logging.info(f'Writing channel {i+1} of {basename} to {output_file}')
        
        # Extract single channel and write as mono
        channel_data = data[:, i]
        sf.write(output_file, channel_data, sample_rate)
        
        mono_files.append(output_file)

    return mono_files