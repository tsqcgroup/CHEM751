#!/bin/bash
module purge
module load tools/tcsh
module load tools/git
module load compiler/GCCcore/14.3.0
module load mpi/OpenMPI/5.0.8-GCC-14.3.0 
module load devel/CMake/4.0.3-GCCcore-14.3.0
module load lang/Python/3.13.5-GCCcore-14.3.0 

export PATH=$HOME/bin:${PATH}
export PATH=$HOME/.local/bin:$PATH
source $HOME/.bash_profile
