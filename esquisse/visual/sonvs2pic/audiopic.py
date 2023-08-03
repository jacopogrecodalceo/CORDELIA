import cv2
import numpy as np
import librosa
import os


pic = "/Users/j/Documents/pics/_eva/Dqg0ueYWsAAxc-F.jpg"
audio = "/Users/j/Downloads/eduaredotempesta_2_.mp3"

pic_name = os.path.splitext(os.path.basename(pic))[0]
pic_dir = os.path.dirname(pic)

pic_data = cv2.imread(pic)
audio_data, sampling_rate = librosa.load(audio, sr=None, mono=True)

# Normalize audio data to the range [0, 1] to make it compatible with librosa
audio_data = audio_data.astype(np.float32)  # Convert audio data to floating-point format
audio_data /= np.max(np.abs(audio_data))  # Normalize to the range [-1, 1]

# Resize audio data to match the shape of pic_data
n_mfcc = 4  # You can adjust this value based on your requirements
audio_mfcc = librosa.feature.mfcc(y=audio_data, sr=sampling_rate, n_mfcc=n_mfcc)

audio_data_resized = cv2.resize(audio_mfcc, (pic_data.shape[1], pic_data.shape[0]), interpolation=cv2.INTER_LANCZOS4)
audio_data_resized = audio_data_resized.astype(np.uint8)[::-1]

# Define the range for random mixing ratio values (adjust these values as needed)
min_ratio = -1
max_ratio = 1.75

# Generate random mixing ratios for each channel of the image (3 channels for RGB images)
ran1 = (max_ratio - min_ratio) * np.random.rand(pic_data.shape[0], pic_data.shape[1], 1)
ran2 = (max_ratio - min_ratio) * np.random.rand(pic_data.shape[0], pic_data.shape[1], 1)

channel_to_modify = 2

# Extract the chosen dimension from the picture data
image_dimension = pic_data[:, :, channel_to_modify]

# Convert the extracted image dimension to audio using librosa
audio_data_from_image = np.array(image_dimension.flatten(), dtype=float) / 255.0  # Normalize to the range [0, 1]

# Apply a delay to the audio data
delay_samples = int(sampling_rate/512)  # Adjust the delay time as needed
delayed_audio = np.concatenate((audio_data_from_image[delay_samples:], np.zeros(delay_samples)))


# Reconvert the delayed audio back to the image dimension
delayed_image_dimension = (delayed_audio * 255.0).astype(np.uint8)

# Replace the original image dimension with the delayed image dimension
pic_data[:, :, channel_to_modify] = delayed_image_dimension.reshape(image_dimension.shape)

# Mix the arrays together using element-wise arithmetic operations
glitch_image = pic_data + ran2 * audio_data_resized[:, :, np.newaxis]

# Ensure that the glitch_image is within the correct data type range
glitch_image = np.clip(glitch_image, 0, 255).astype(np.uint8)
print((pic_data, glitch_image))

# Display the original and glitched images side by side
# combined_image = np.hstack((pic_data, glitch_image))
cv2.imshow("Original Image vs Glitched Image", glitch_image)
cv2.waitKey(0)
cv2.destroyAllWindows()
#cv2.imwrite(os.path.join(pic_dir, pic_name + '-pyglitch.png'), glitch_image)
