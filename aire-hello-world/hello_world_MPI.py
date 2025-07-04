import ctypes
from ctypes import wintypes
import os
import socket

from mpi4py import MPI

print(f'Hostname: {socket.gethostname()}')

world_comm = MPI.COMM_WORLD
world_size = world_comm.Get_size()
rank = world_comm.Get_rank()

print("MPI Details:")
print(f'    - World size: {world_size}')
print(f'    - Rank: {rank}')

print("Processor Details:")

name = os.name
if (name == "nt"):
    class PROCESSOR_NUMBER(ctypes.Structure):
        _fields_ = [("Group", wintypes.WORD),
            ("Number", wintypes.BYTE),
            ("Reserved", wintypes.BYTE)]
    
    pn = PROCESSOR_NUMBER()
    ctypes.windll.kernel32.GetCurrentProcessorNumberEx(ctypes.byref(pn))
    
    print(f'    - Group: {pn.Group}')
    print(f'    - Number: {pn.Number}')
elif (name == "posix"):
    libc = ctypes.CDLL("libc.so.6")
    print(f'    - Number: {libc.sched_getcpu()}')
print("")