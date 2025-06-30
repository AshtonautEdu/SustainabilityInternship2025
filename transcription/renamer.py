import sys
import os

if (len(sys.argv) < 2):
    sys.exit("Missing input file path.\nusage: python renamer.py input_filepath [names...]")

input_path = sys.argv[1]
input_filename, ext = os.path.splitext(input_path)
output_path = f'{input_filename}-renamed.vtt'

if (ext != ".vtt"):
    sys.exit(".vtt file expected")

try:
    input_file = open(input_path, "r")
except:
    sys.exit(f'Failed to open input file at \"{input_path}\"')
try:
    output_file = open(output_path, "w")
except:
    sys.exit(f'Failed to open output file at \"{output_path}\"')

lines = input_file.readlines()
for line in lines:
    for number, name in enumerate(sys.argv[2:]):
        tag = f'[SPEAKER_{number:02}]'
        if line.startswith(tag):
            line = line.replace(tag, name, 1)
    output_file.write(line)