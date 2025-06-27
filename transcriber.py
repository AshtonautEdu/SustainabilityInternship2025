from os import environ
from dotenv import load_dotenv
import subprocess
import sys

load_dotenv()
token = environ["TOKEN"]

machineArgs = {
    "laptop": {
        "compute_type": "int8",
    }
}
machine = machineArgs["laptop"]

if (len(sys.argv) > 2):
    sys.exit("Too many arguments.\nusage: python transcriber.py [speaker_count]")

command = [
    "whisperx",
    ".\\audio-files\\test.mp3",
    "--diarize",
    "--hf_token", f'{token}',
    "--compute_type", f'{machine["compute_type"]}',
    "--output_format", "vtt",
]

if (sys.argv[1] != None):
    speaker_count = sys.argv[1]
    try:
        speaker_count = int(speaker_count)
        if (speaker_count <= 0):
            raise Exception()
    except:
        sys.exit("Invalid speaker count input. Positive integer expected.")
    
    command = command + [
        "--min_speakers", f'{speaker_count}',
        "--max_speakers", f'{speaker_count}',
    ]
    
print(command)

subprocess.run(command)