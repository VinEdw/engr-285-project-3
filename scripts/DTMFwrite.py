#Program to encode a sequence of single digits into a DTMF sound (written to a .wav file)

import numpy as np
import wave #Necessary for writing the .wav file
import struct #Necessary for writing the .wav file

fileName = "media/TestSignals/TenDigits.wav" #Output file name (must include .wav)

numberList = [0,1,2,3,4,5,6,7,8,9] #List of digits (0-9) to be encoded into sound

sampleRate = 44100
soundLevel = 4096
soundLength = 400
pauseLength = 200

def createPureToneData(freq):
    return np.array([soundLevel/2 * np.sin(2.0 * np.pi * freq * x / sampleRate) for x in range(0, sampleRate)]).astype(np.int16)

array697 = createPureToneData(697)
array770 = createPureToneData(770)
array852 = createPureToneData(852)
array941 = createPureToneData(941)
array1209 = createPureToneData(1209)
array1336 = createPureToneData(1336)
array1477 = createPureToneData(1477)

toneList = [sum([array941,array1336]).tolist(),sum([array697,array1209]).tolist(),sum([array697,array1336]).tolist(),sum([array697,array1477]).tolist(),sum([array770,array1209]).tolist(),sum([array770,array1336]).tolist(),sum([array770,array1477]).tolist(),sum([array852,array1209]).tolist(),sum([array852,array1336]).tolist(),sum([array852,array1477]).tolist()]

soundData = []
for i in range(len(numberList)):
    soundData += toneList[numberList[i]][:int(sampleRate*soundLength/1000)]
    soundData += [0] * int(sampleRate*pauseLength/1000)

#Start to write the .wav file
wav_file = wave.open(fileName, "w")

#Parameters for the .wav file
nchannels = 1
sampwidth = 2
framerate = int(sampleRate)
nframes = (int(sampleRate*soundLength/1000)+int(sampleRate*pauseLength/1000))*len(numberList)
comptype = "NONE"
compname = "not compressed"

wav_file.setparams((nchannels, sampwidth, framerate, nframes,
    comptype, compname))

#Write the data to the file
for s in soundData:
    wav_file.writeframes(struct.pack('h', int(s)))

wav_file.close() #Finish writing the .wav file

print("Writing " + fileName + " complete!")
