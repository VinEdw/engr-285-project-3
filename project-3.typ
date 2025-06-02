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

#py_script("DTMFfrequencies", put_fname: true, put_output: false)

= Encoding Program

#py_script("DTMFwrite", put_fname: true)

= Decoding Program

#py_script("DTMFread", put_fname: true)

= Sending Alphanumeric Messages

