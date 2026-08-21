#!/bin/bash
#SBATCH -N 1
#SBATCH -t 01:00:00
#SBATCH --account=chem751 --partition=chem751
#SBATCH --mem=4G
#SBATCH --ntasks-per-node=1


file=$1
echo $file
inp=`realpath $file`
output=${inp%.inp}.log
name=${inp%.inp}

module purge
module load tools/tcsh
module load tools/git
module load compiler/GCCcore/14.3.0
module load mpi/OpenMPI/5.0.8-GCC-14.3.0
module load devel/CMake/4.0.3-GCCcore-14.3.0
module load lang/Python/3.13.5-GCCcore-14.3.0

export PMIX_MCA_psec=^munge
NNODES=$SLURM_NNODES
PPN2=$((SLURM_NTASKS/SLURM_NNODES))
PPN=$((PPN2/2))
NCPUS2=$((SLURM_NNODES*PPN2))



GMSPATH=/mnt/lustre/koa/class/chem751_class/installed_software/gms_mpi_noDS

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

  rm -r $SCR
 srun $GMSPATH/bin/my_ipcrm

