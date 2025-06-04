import numpy as np
import matplotlib.pyplot as plt

sample_rate = 44100
sound_level = 4096
# Set the sound and pause lengths in milliseconds
sound_length = 2000

# Use the sound/pause lengths and sample rate to calculate how many samples are need for each
sound_samples = sample_rate * sound_length // 1000

def create_pure_tone_data(freq):
    data = []
    amplitude = sound_level / 2
    omega = 2.0 * np.pi * freq
    for x in range(sound_samples):
        angle = omega * x / sample_rate
        value = amplitude * np.sin(angle)
        data.append(value)
    return np.array(data, dtype="int16")

# Calculate the approximate Fourier coefficient of the input signal data for the given frequency
def calculate_coefficient(data_sample, freq):
    a = 0
    b = 0
    N = len(data_sample)
    for i in range(N):
        y = data_sample[i]
        t = i / sample_rate
        a += y * np.cos(2 * np.pi * freq * t)
        b += y * np.sin(2 * np.pi * freq * t)
    return 2/N * np.sqrt(a**2 + b**2)

f_1 = 2
f_2 = 5
dual_tone = create_pure_tone_data(f_1) + create_pure_tone_data(f_2)
freq_values = np.linspace(0, 8, 800)
coefficients = [calculate_coefficient(dual_tone, freq) for freq in freq_values]

fig, axes = plt.subplots(2, 1, figsize=(6.4, 9.6))

time = np.arange(sound_samples) / sample_rate
axes[0].plot(time, dual_tone, "C0")
axes[0].set(ylabel=r"$y$", xlabel=r"$t$ (s)", title=f"Dual Tone ({f_1} Hz + {f_2} Hz)")

axes[1].plot(freq_values, coefficients, "C1")
axes[1].set(ylabel=r"$\sqrt{a_\nu^2 + b_\nu^2}$", xlabel=r"$\nu$ (Hz)", title="Fourier Coefficients")

fig.tight_layout()
fig.savefig("media/fourier_transform_demo.svg")
