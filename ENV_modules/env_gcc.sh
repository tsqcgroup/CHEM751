#!/bin/bash
module purge
module load compiler/GCC/12.2.0 devel/CMake/3.24.3-GCCcore-12.2.0 
module load mpi/OpenMPI/4.1.4-GCC-12.2.0 
module load lang/Python/3.10.8-GCCcore-12.2.0
module load tools/git tools/tcsh
