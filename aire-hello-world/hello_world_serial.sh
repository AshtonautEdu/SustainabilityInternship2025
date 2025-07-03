#!/bin/bash
#SBATCH --job-name=hello_world_serial
#SBATCH --output=output_%j.out
#SBATCH --error=error_%j.err
#SBATCH --time=00:01:00

module load miniforge/24.7.1
conda activate aire-hello-world

python hello_world_serial.py
