#import "engr-conf.typ": conf, py_script

#show: conf.with(
  title: [Dual Tone Multi-Frequency (DTMF) Signaling],
  authors: (
    (first_name: "Vincent", last_name: "Edwards"),
    (first_name: "Julia", last_name: "Corrales"),
    (first_name: "Rachel", last_name: "Gossard"),
  ),
  date: datetime(year: 2025, month: 6, day: 10),
)

// #image("media/thumbnail.svg")

// Table of contents
#pagebreak()
#outline()
#pagebreak()

= DTMF Description

Dual-tone multi-frequency signals (DTMF) combine two pure tone sinusoids as a method of encoding or decoding digital information.
This was first developed by the Bell System in 1963 and is commonly known as "Touch-Tone", and it was used in push-button telephones.
Each digit corresponds to a unique combination of one high frequency and one low frequency.
@digit_encoding_scheme shows the low frequency in the first column and the high frequency in the first row associated with each digit from 0 to 9.
For this project's objectives, only numbers 0 to 9 were used.

#figure(
  caption: [Digit Encoding Scheme],
  table(
    columns: 4,
    table.header([],[1209 Hz],[1336 Hz],[1477 Hz]),
    [675 Hz],[1],[2],[3],
    [770 Hz],[4],[5],[6],
    [852 Hz],[7],[8],[9],
    [941 Hz],[],[0],[],
  ),
) <digit_encoding_scheme>

This matrix represents the most common arrangement of a DTMF telephone keypad, with the fourth row often reserved for symbols and 0. 
Pressing a key will send a superimposed combination of the low and high frequencies, where the sound of each dual-tone will play for a certain duration. 
A receiver will decode each dual-tone by performing Fourier analysis and determine the two most prominent frequencies. 

`DTMFfrequencies.py` stores lists containing the high and low frequencies.
This allows the frequencies to be accessed in the reading and writing programs without duplication.
The `decode_matrix` stores the digit associated with each low and high frequency, similar to @digit_encoding_scheme.
-1 was put in place of unused frequency combinations.
The `encode_dict` is a dictionary that maps each digit to its corresponding frequency pair.
It was created by looping through the entries of the `decode_matrix`, searching for values between 0 and 9, then saving the position's pair of frequencies in the dictionary using the current digit as the index.

#py_script("DTMFfrequencies", put_fname: true, put_output: false)

= Encoding Program

#py_script("DTMFwrite", put_fname: true)

= Decoding Program

#py_script("DTMFread", put_fname: true)

= Sending Alphanumeric Messages

