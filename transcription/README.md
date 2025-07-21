# /transcription/

This directory contains Python (3.11) scripts for transcribing audio files to text and assigning arbitrary speaker labels (transcriber.py), and for renaming said speaker labels (renamer.py).

It's low-priority, but given more time, I'd quite like to:
- Make the diarisation optional, as it currently takes the lion's share of total computation time
- Make different profiles for different machines to adjust model parameters and choose between GPU/CPU
