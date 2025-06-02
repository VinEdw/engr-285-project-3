# Program to read in and decode DTMF sound data from a .wav file

import DTMFfrequencies as freqs
import numpy as np
import matplotlib.pyplot as plt # Necessary if you want to plot the waveform (commented out lines at the end)
import wave # Necessary for reading the .wav file
import struct # Necessary for reading the .wav file

# These first few blocks read in the .wav file to an ordinary integer data list
file_name = "media/TestSignals/TenDigits.wav"
plot_name = "media/TenDigitsPlot.svg"

wavefile = wave.open(file_name, 'r')

length = wavefile.getnframes()
framerate = wavefile.getframerate()
save_data = []
for i in range(0, length):
    wavedata = wavefile.readframes(1)
    data = struct.unpack("<h", wavedata)
    save_data.append(int(data[0]))
# At this point the sound data is saved in the save_data variable

def slice_data():
    i = 0
    data_list = []
    streak_length = 2
    while i < length:
        if not any(save_data[i:i+streak_length]):
            i += 1
        else:
            j = 0
            current_signal = []
            while any(save_data[i+j:i+j+streak_length]):
                current_signal.append(save_data[i+j])
                j += 1
            data_list.append(current_signal)
            i += j + 1
    return data_list

def calculate_coefficient(data_sample, freq):
    a = 0
    b = 0
    N = len(data_sample)
    for i in range(N):
        y = data_sample[i]
        t = i / framerate
        a += y * np.cos(2 * np.pi * freq * t)
        b += y * np.sin(2 * np.pi * freq * t)
    return 2/N * np.sqrt(a**2 + b**2)

def decode_freqs(low_freq, high_freq):
    low_idx = freqs.low.index(low_freq)
    high_idx = freqs.high.index(high_freq)
    return freqs.decode_matrix[low_idx][high_idx]

sliced_data = slice_data()

for signal in sliced_data:
    low_coeffs = [calculate_coefficient(signal, freq) for freq in freqs.low]
    high_coeffs = [calculate_coefficient(signal, freq) for freq in freqs.high]
    low_freq = freqs.low[np.argmax(low_coeffs)]
    high_freq = freqs.high[np.argmax(high_coeffs)]

    print(decode_freqs(low_freq, high_freq), end="")

print()

fig, ax = plt.subplots()
ax.set(ylabel="$y$", xlabel="$t$ (s)")

time = np.arange(length) / framerate
ax.plot(time, save_data)

fig.savefig(plot_name)
