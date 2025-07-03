from mpi4py import MPI

world_comm = MPI.COMM_WORLD
world_size = world_comm.Get_size()
rank = world_comm.Get_rank()

print(f'World Size: {world_size}  Rank: {rank}')