import cv2
import numpy as np
import librosa
import os

audio = "/Users/j/Documents/PROJECTs/je_monstre/2308-paris_poisson/_reaper-render/20230817-3-post-cordelia.wav"
pic = "/Users/j/Documents/pics/_chainsaw man/chainsaw_man-3.jpg"
width, height = 960, 540

audio_name = os.path.splitext(os.path.basename(audio))[0]
audio_dir = os.path.dirname(audio)

def print_info(arr):
    # Print dimension
    print("Dimension:", arr.ndim)

    # Print shape
    print("Shape:", arr.shape)

    # Print size (total number of elements)
    print("Size:", arr.size)

    # Print data type
    print("Data type:", arr.dtype)

    # Print strides (the number of bytes to step in each dimension when traversing the array)
    print("Strides:", arr.strides)

    # Print itemsize (the size in bytes of each element)
    print("Item size (bytes):", arr.itemsize)

    # Print a summary of the array content
    print("Array:")
    max_elements_to_display = 10  # You can adjust this number as needed
    if arr.size <= 2 * max_elements_to_display:
        # If the array is small, print the entire content
        print(arr)
    else:
        # Otherwise, print the beginning and end of the array
        print(np.concatenate((arr[:max_elements_to_display], arr[-max_elements_to_display:])))

audio_data, sampling_rate = librosa.load(audio, sr=None, mono=True)


# Resize audio data to match the shape of pic_data
n_mfcc = 12  # You can adjust this value based on your requirements
audio_mfcc = librosa.feature.mfcc(y=audio_data, sr=sampling_rate, n_mfcc=n_mfcc)

interpolations = [
    cv2.INTER_AREA,
    cv2.INTER_BITS,
    cv2.INTER_CUBIC,
    cv2.INTER_LANCZOS4,
    cv2.INTER_LINEAR,
    cv2.INTER_LINEAR_EXACT,
    cv2.INTER_NEAREST
    ]

images = []

for i in interpolations:
    audio_data_resized = cv2.resize(audio_mfcc, (width, height), interpolation=i)
    audio_data_resized = audio_data_resized.astype(np.uint8)
    # Mix the arrays together using element-wise arithmetic operations
    audio_image = audio_data_resized[:, :, np.newaxis]
    images.append(audio_image)

combined_image = np.hstack(images)

show = True
if show:
    cv2.imshow("Interp audio images", audio_image)
    cv2.waitKey(0)
    cv2.destroyAllWindows()
#cv2.imwrite(os.path.join(pic_dir, pic_name + '-pyglitch.png'), glitch_image)
