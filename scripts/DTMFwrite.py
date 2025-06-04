# Program to encode a sequence of single digits into a DTMF sound (written to a .wav file)

import DTMFfrequencies as freqs
import numpy as np
import wave # Necessary for writing the .wav file
import struct # Necessary for writing the .wav file

file_name = "media/TestSignals/TenDigits.wav" # Output file name (must include .wav)

number_list = [0,1,2,3,4,5,6,7,8,9] # List of digits (0-9) to be encoded into sound

sample_rate = 44100
sound_level = 4096
# Set the sound and pause lengths in milliseconds
sound_length = 400
pause_length = 200

# Use the sound/pause lengths and sample rate to calculate how many samples are need for each
sound_samples = sample_rate * sound_length // 1000
pause_samples = sample_rate * pause_length // 1000

def create_pure_tone_data(freq):
    data = []
    amplitude = sound_level / 2
    omega = 2.0 * np.pi * freq
    for x in range(sound_samples):
        angle = omega * x / sample_rate
        value = amplitude * np.sin(angle)
        data.append(value)
    return np.array(data, dtype="int16")

pure_tone_data = {freq: create_pure_tone_data(freq) for freq in (freqs.low + freqs.high)}

# Create a list that maps digits to their corresponding dual tone
tone_list = [[]] * 10
for digit in range(10):
    low_freq, high_freq = freqs.encode_dict[digit]
    tone_list[digit] = (pure_tone_data[low_freq] + pure_tone_data[high_freq]).tolist()

# Create a list with the tone and pause for each digit of the number list
sound_data = []
for digit in number_list:
    sound_data += tone_list[digit]
    sound_data += [0] * pause_samples

# Start to write the .wav file
wav_file = wave.open(file_name, "w")

# Parameters for the .wav file
nchannels = 1
sampwidth = 2
framerate = int(sample_rate)
nframes = (sound_samples + pause_samples) * len(number_list)
comptype = "NONE"
compname = "not compressed"

wav_file.setparams((nchannels, sampwidth, framerate, nframes,
    comptype, compname))

# Write the data to the file
for s in sound_data:
    wav_file.writeframes(struct.pack('h', int(s)))

wav_file.close() # Finish writing the .wav file

print("Writing " + file_name + " complete!")
