from mpi4py import MPI
import ctypes
from ctypes import wintypes

world_comm = MPI.COMM_WORLD
world_size = world_comm.Get_size()
rank = world_comm.Get_rank()

print("MPI Details:")
print(f'World Size: {world_size}  Rank: {rank}')

class PROCESSOR_NUMBER(ctypes.Structure):
    _fields_ = [("Group", wintypes.WORD),
                ("Number", wintypes.BYTE),
                ("Reserved", wintypes.BYTE)]
    
pn = PROCESSOR_NUMBER()

ctypes.windll.kernel32.GetCurrentProcessorNumberEx(ctypes.byref(pn))

print("Processor Details:")
print(f'Group: {pn.Group}  Number: {pn.Number}\n')