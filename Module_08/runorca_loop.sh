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
module load mpi/OpenMPI/4.1.6-GCC-13.2.0 

#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

ORCAdir=/mnt/lustre/koa/class/chem751_class/installed_software/orca
MPIdir="/opt/apps/software/mpi/OpenMPI/4.1.6-GCC-13.2.0/bin"
export PATH="$ORCAdir:$MPIdir:$PATH"
export LD_LIBRARY_PATH="$ORCAdir:$MPIdir:$LD_LIBRARY_PATH"
work=`pwd`
ORCAexe=$ORCAdir/orca
for file in *inp; do
SCRdir=/mnt/lustre/koa/scratch/$USER/$SLURM_JOB_ID
mkdir $SCRdir
#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#file=$1
echo $file
name=${file%.inp}
INPUT=${name}.inp
fpath=`realpath $file`
OUTPUT=${fpath%.inp}.log
#name=${inp%.inp}


# Get things read in the scratch directory
cp $fpath $SCRdir
cd $SCRdir

echo "Start: "$(date)
echo $SLURMD_NODENAME
# Submit the job!
$ORCAexe ${INPUT} > $OUTPUT

#cp $SCRdir/${name}.densitiesinfo $work 
#cp $SCRdir/${name}.bibtex        $work 
#cp $SCRdir/${name}.densities     $work 
#cp $SCRdir/${name}.gbw           $work 
cp $SCRdir/${name}.xyz           $work 
#cp $SCRdir/${name}.property.txt  $work 


#cp $SCRdir/${name}.densities       $work 
#cp $SCRdir/${name}.densitiesinfo   $work 
#cp $SCRdir/${name}.gbw             $work 
#cp $SCRdir/${name}.hostnames       $work 
#cp $SCRdir/${name}.inp             $work 
#cp $SCRdir/${name}.log             $work 
#cp $SCRdir/${name}.opt             $work 
#cp $SCRdir/${name}.property.txt    $work 
#cp $SCRdir/${name}.xyz             $work 


cd $work


rm -rf $SCRdir

done
echo "Finish: "$(date)

