# Program to encode a sequence of single digits into a DTMF sound (written to a .wav file)

import numpy as np
import wave # Necessary for writing the .wav file
import struct # Necessary for writing the .wav file

file_name = "media/TestSignals/TenDigits.wav" # Output file name (must include .wav)

number_list = [0,1,2,3,4,5,6,7,8,9] # List of digits (0-9) to be encoded into sound

sample_rate = 44100
sound_level = 4096
sound_length = 400
pause_length = 200

def create_pure_tone_data(freq):
    return np.array([sound_level/2 * np.sin(2.0 * np.pi * freq * x / sample_rate) for x in range(0, sample_rate)]).astype(np.int16)

array697 = create_pure_tone_data(697)
array770 = create_pure_tone_data(770)
array852 = create_pure_tone_data(852)
array941 = create_pure_tone_data(941)
array1209 = create_pure_tone_data(1209)
array1336 = create_pure_tone_data(1336)
array1477 = create_pure_tone_data(1477)

tone_list = [sum([array941,array1336]).tolist(),sum([array697,array1209]).tolist(),sum([array697,array1336]).tolist(),sum([array697,array1477]).tolist(),sum([array770,array1209]).tolist(),sum([array770,array1336]).tolist(),sum([array770,array1477]).tolist(),sum([array852,array1209]).tolist(),sum([array852,array1336]).tolist(),sum([array852,array1477]).tolist()]

sound_data = []
for i in range(len(number_list)):
    sound_data += tone_list[number_list[i]][:int(sample_rate*sound_length/1000)]
    sound_data += [0] * int(sample_rate*pause_length/1000)

# Start to write the .wav file
wav_file = wave.open(file_name, "w")

# Parameters for the .wav file
nchannels = 1
sampwidth = 2
framerate = int(sample_rate)
nframes = (int(sample_rate*sound_length/1000)+int(sample_rate*pause_length/1000))*len(number_list)
comptype = "NONE"
compname = "not compressed"

wav_file.setparams((nchannels, sampwidth, framerate, nframes,
    comptype, compname))

# Write the data to the file
for s in sound_data:
    wav_file.writeframes(struct.pack('h', int(s)))

wav_file.close() # Finish writing the .wav file

print("Writing " + file_name + " complete!")
