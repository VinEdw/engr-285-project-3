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

#figure(
  caption: [Finding Fourier Coefficients Demo],
  image("media/fourier_transform_demo.svg", width: 80%),
)

// Table of contents
#pagebreak()
#outline()
#pagebreak()

= DTMF Description

Dual-tone multi-frequency signals (DTMF) combine two pure tone sinusoids as a method of encoding or decoding digital information.
This was first developed by the Bell System in 1963, commonly known as "Touch-Tone", and it was used in push-button telephones.
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

`DTMFwrite.py` is used to create a `.wav` file that contains a sequence of DTMF signals separated by pauses for the entered digit sequence.

The program starts by importing necessary packages.
Next, there are multiple variables that the user is free to set to adjust the behavior of the script.
These variables include the following:
- `file_name`: file location to save the `.wav` file
- `number_list`: list of digits to encode in the signal
- `sample_rate`: frequency in Hz at which points should be sampled from a pure sinusoid
- `sound_level`: amplitude of the sum of two sinusoids; note that this must fit within a 16 bit signed integer (between $-2^15$ and $2^15 - 1$)
- `sound_length`: how long each dual tone should last in milliseconds
- `pause_length`: how long each pause should last in milliseconds

== Signal Sample Amounts

Then, the program calculates how many `sound_samples` and `pause_samples` are needed based on the `sampling_rate`, `sound_length`, and `pause_length`.
If the `sampling_rate` is represented by $f_s$, then to get the time between samples $T_s$ is
$
T_s = 1/f_s
$ <sampling_period_and_frequency>
Thus, to find the number of samples $n$ needed for a duration $t$, the duration can be divided by the time between samples.
$
n = t/T_s = f_s t
$ <time_to_sample>
Note that the times in milliseconds were divided by 1000 to convert them to seconds.
That way multiplying by the `sampling_rate` in Hz gives a unitless result.

To go in reverse from sample number to time, you can rearrange @time_to_sample to get
$
t = T_s n = n/f_s
$ <sample_to_time>

#py_script("DTMFwrite", put_fname: true)

= Decoding Program

#py_script("DTMFread", put_fname: true)

= Handling More Complicated Messages

With the current encoding scheme, only digits (0-9) can be sent in messages.
One might wish to expand the encoding and decoding programs to support messages containing more complicated information, such as letters and symbols.
Let $C$ refer to the number of different characters available.

To start, notice that @digit_encoding_scheme has two unused frequency combinations.
Those unused combinations could be used to add two more characters to the encoding scheme.
The desired characters would be put in the `decode_matrix`.
But, there are still only $4 times 3 = 12$ frequency pairs, and thus characters available. 
One technique to increase the number of characters available would be to increase the number of low frequencies and/or the number of high frequencies.
These new frequencies would be added to the `low` and `high` frequency lists, and the size of the `decode_matrix` would be expanded to match the sizes of the frequency lists.
If we use $n_1$ to refer to the number of low frequencies and $n_2$ to refer to the number of high frequencies, then number of characters available is
$
C = n_1 n_2
$
If the goal is to be able to send digits and uncased letters, then $26 + 10 = 36$ characters are needed and it is required that $n_1 n_2 >= 36$.
One possible choice for $n_1$ and $n_2$ is $n_1 = n_2 = 6$.
If the goal is to also include characters such as spaces, commas, and periods, then $n_1$ or $n_2$ can be increased to 7, giving 42 possible characters. 

Another technique that could be used is mapping sequences of preliminary characters to different characters.
Each frequency pair would correspond to a specific preliminary character as in the previous technique.
Then, sequences of preliminary characters would be mapped to a final character.
For example, a 4 followed by a 1 could map to `A`, a 4 followed by a 2 could map to `B`, and so on.
The encoding program would need to be modified to have a function, dictionary, or matrix that maps message characters to sequences of preliminary characters.
Those preliminary characters could then be encoding into the signal as before.
The decoding program would function the same initially, turning signals into preliminary characters.
Then, a function, dictionary, or matrix would be needed to map sequences of preliminary characters to message characters.
Using sequences with a fixed length of $l$, the number of characters available is
$
C = (n_1 n_2)^l
$
If $n_1 = 4$ and $n_2 = 3$ as in the default scheme and $l = 2$, then that gives $(4 times 3)^2 = 144$ possible characters.
That is more than enough to cover any of the 128 ASCII characters.
This technique has the advantage of not requiring any new frequencies, thought it has the disadvantage of making messages $l$ times longer.

A third technique that could be used is introducing additional sets of frequencies, perhaps higher or lower than the current sets.
If $k$ frequency sets are used in total, then each character in the message would consist of $k$ pure sinusoids.
In order for the combined signal to have a maximum amplitude equal to `sound_level`, the individual sinusoids would need their amplitude set equal to the `sound_level / k`.
Next, each of these new frequency sets would need to have their list of frequencies stored in a variable.
To make all these frequency lists easier to manage, perhaps they could be put in a list.
That way, the program could loop over the frequencies in each frequency list.
Lastly, the `decode_matrix` would then need to be expanded to have `k` dimensions with lengths corresponding to the number of frequencies in each frequency list.
The number of characters available when using $k$ frequency sets each with length $n_i$ is
$
C = product_(i=1)^k n_i
$
If $k = 3$, $n_1 = 4$, $n_2 = 3$, and $n_3 = 3$, then that gives $4 times 3 times 3 = 36$ characters, enough to send digits and uncased letters.
Similar to the first technique, this technique does not increase the length of the message, though it does require introducing new frequencies.
However, not as many distinct frequencies need to be used as the first technique.
While the first technique required $6 + 6 = 12$ frequencies to encode 36 characters, this technique requires $4 + 3 + 3 = 10$ frequencies to encode the same amount of characters.
