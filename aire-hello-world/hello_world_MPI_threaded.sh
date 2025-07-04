#!/bin/bash
#SBATCH --job-name=hello_world_MPI_threaded
#SBATCH --time=00:01:00
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --cpus-per-task=1
#SBATCH --output=output_%j.out

module load miniforge

mpiexec -n 4 python ./hello_world_MPI.py
