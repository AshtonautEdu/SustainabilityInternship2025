import ctypes
from ctypes import wintypes
import os

from mpi4py import MPI

world_comm = MPI.COMM_WORLD
world_size = world_comm.Get_size()
rank = world_comm.Get_rank()

print("MPI Details:")
print(f'World Size: {world_size}  Rank: {rank}')

print("Processor Details:")

name = os.name
if (name == "nt"):
    class PROCESSOR_NUMBER(ctypes.Structure):
        _fields_ = [("Group", wintypes.WORD),
            ("Number", wintypes.BYTE),
            ("Reserved", wintypes.BYTE)]
    
    pn = PROCESSOR_NUMBER()
    ctypes.windll.kernel32.GetCurrentProcessorNumberEx(ctypes.byref(pn))
    
    print(f'Group: {pn.Group}  Number: {pn.Number}\n')
elif (name == "posix"):
    libc = ctypes.CDLL("libc.so.6")
    print(f'Number: {libc.sched_getcpu()}')