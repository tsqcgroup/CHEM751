#!/bin/bash
#SBATCH --job-name=Orca
#SBATCH --partition=chem751 --account=chem751
#SBATCH --time=00:10:00 ## time format is DD-HH:MM:SS
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=2
#SBATCH --mem=5G

ulimit -s unlimited


#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

module purge
module load tools/tcsh
module load tools/git
module load compiler/GCCcore/14.3.0
module load mpi/OpenMPI/5.0.8-GCC-14.3.0
module load devel/CMake/4.0.3-GCCcore-14.3.0
module load lang/Python/3.13.5-GCCcore-14.3.0

#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

ORCAdir=/mnt/lustre/koa/class/chem751_class/installed_software/orca_6.1.1
MPIdir="/opt/apps/software/mpi/OpenMPI/5.0.8-GCC-14.3.0/bin"
export PATH="$ORCAdir:$MPIdir:$PATH"
export LD_LIBRARY_PATH="$ORCAdir:$MPIdir:$LD_LIBRARY_PATH"
work=`pwd`
ORCAexe=$ORCAdir/orca
SCRdir=/mnt/lustre/koa/scratch/$USER/$SLURM_JOB_ID
#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
file=$1
echo $file
name=${file%.inp}
INPUT=${name}.inp
fpath=`realpath $file`
OUTPUT=${fpath%.inp}.log
#name=${inp%.inp}

mkdir $SCRdir

# Get things read in the scratch directory
cp $fpath $SCRdir
cd $SCRdir

echo "Start: "$(date)
echo $SLURMD_NODENAME
# Submit the job!
$ORCAexe ${INPUT} > $OUTPUT

cp $SCRdir/${name}.xyz           $work 


cd $work


rm -rf $SCRdir

echo "Finish: "$(date)


