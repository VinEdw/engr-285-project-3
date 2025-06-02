# Program to store the DTMF frequencies and the decoding matrix

low = [697, 770, 852, 941]
high = [1209, 1336, 1477]

decode_matrix = [
    [ 1, 2, 3],
    [ 4, 5, 6],
    [ 7, 8, 9],
    [-1, 0,-1],
]

encode_list = [(-1, -1)] * 10
for i, row in enumerate(decode_matrix):
    low_freq = low[i]
    for j, digit in enumerate(row):
        high_freq = high[j]
        if digit not in range(10):
            continue
        encode_list[digit] = (low_freq, high_freq)
