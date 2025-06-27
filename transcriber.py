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

if not (2 <= len(sys.argv) <= 3) :
    sys.exit("Too many arguments.\nusage: python transcriber.py input_filepath [speaker_count]")

input_path = sys.argv[1]

command = [
    "whisperx",
    f'{input_path}',
    "--diarize",
    "--hf_token", f'{token}',
    "--compute_type", f'{machine["compute_type"]}',
    "--output_format", "vtt",
]

if (len(sys.argv) == 3):
    speaker_count = sys.argv[2]
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
    
subprocess.run(command)