#!/bin/bash
#SBATCH -N 1
#SBATCH -t 01:00:00
#SBATCH --account=chem751 --partition=chem751
#SBATCH --mem=4G
#SBATCH --ntasks-per-node=2

##SBATCH --partition=shared,kill-shared,exclusive,kill-exclusive --mem=40G

file=$1
echo $file
inp=`realpath $file`
output=${inp%.inp}.log
name=${inp%.inp}

module purge
module load compiler/GCC/12.2.0 devel/CMake/3.24.3-GCCcore-12.2.0 
module load mpi/OpenMPI/4.1.4-GCC-12.2.0 
module load lang/Python/3.10.8-GCCcore-12.2.0
module load tools/git tools/tcsh

export PMIX_MCA_psec=^munge
NNODES=$SLURM_NNODES
PPN2=$((SLURM_NTASKS/SLURM_NNODES))
PPN=$((PPN2/2))
NCPUS2=$((SLURM_NNODES*PPN2))



GMSPATH=/mnt/lustre/koa/class/chem751_class/installed_software/gms_mpi

 srun $GMSPATH/bin/my_ipcrm
export SCR=/mnt/lustre/koa/scratch/$USER/$SLURM_JOBID

export USERSCR=${SCR}
export JOB=JOB.${SLURM_JOBID}
source $GMSPATH/gms-files.bash
export INPUT=$USERSCR/${JOB}.F05
export OUTPUT=$USERSCR/${JOB}.F06


mkdir -p $SCR
export currentdir=`pwd`
cp $inp $INPUT
cd $SCR
echo "srun --mpi=pmix -N $NNODES -n $NCPUS2 --ntasks-per-node=$PPN2 --export=ALL --cpu-bind verbose,cores \
  $GMSPATH/gamess.00.x >& $output"

srun --mpi=pmix -N $NNODES -n $NCPUS2 --ntasks-per-node=$PPN2 --export=ALL --cpu-bind verbose,cores \
  $GMSPATH/gamess.00.x >& $output

cd $currentdir

# copy efp file
EFP=$SCR/${JOB}.efp
if [ -e "$EFP" ]; then
  cp $SCR/${JOB}.efp ${name}.efp
fi

# copy dat file
DAT=$SCR/${JOB}.dat
if [ -e "$DAT" ]; then
  cp $SCR/${JOB}.dat ${name}.dat
  cp $SCR/${JOB}.* $currentdir
fi


# remove scratch files
CHKJOB=`ls ${JOB}.* | head -n 1`
if [ -e "$CHKJOB" ]; then
  rm ${JOB}.*
fi

  rm -r $SCR
 srun $GMSPATH/bin/my_ipcrm

