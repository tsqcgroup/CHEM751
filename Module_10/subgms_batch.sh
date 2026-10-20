#!/bin/bash
#------------------------------------------------------------------------------
# Runs ALL *.inp in the directory you submit from, one after another, as a
# single Slurm job:   cd UHF; sbatch ../subgms_batch.sh
# Output: one .log per .inp (+ .dat/.efp if produced). Check jobs: squeue -u $USER
#------------------------------------------------------------------------------
# STEP1: Slurm resources: nodes, time limit, class queue, memory, MPI processes/node
#------------------------------------------------------------------------------
#SBATCH -N 1
#SBATCH -t 01:00:00
#SBATCH --account=chem751 --partition=chem751
#SBATCH --mem=4G
#SBATCH --ntasks-per-node=1


#------------------------------------------------------------------------------
# STEP2: Load the compiler/MPI that GAMESS was built with
#------------------------------------------------------------------------------
module purge
module load tools/tcsh
module load tools/git
module load compiler/GCCcore/14.3.0
module load mpi/OpenMPI/5.0.8-GCC-14.3.0
module load devel/CMake/4.0.3-GCCcore-14.3.0
module load lang/Python/3.13.5-GCCcore-14.3.0

#------------------------------------------------------------------------------
# STEP3: Process counts (SLURM_* variables come from the #SBATCH lines)
#------------------------------------------------------------------------------
export PMIX_MCA_psec=^munge
NNODES=$SLURM_NNODES
PPN2=$((SLURM_NTASKS/SLURM_NNODES))   # processes per node
NCPUS2=$((SLURM_NNODES*PPN2))         # total processes

#------------------------------------------------------------------------------
# STEP4: GAMESS install path and scratch folder (one per Slurm job)
#------------------------------------------------------------------------------
GMSPATH=/mnt/lustre/koa/class/chem751_class/installed_software/gms_mpi_noDS

 srun $GMSPATH/bin/my_ipcrm           # clear leftover shared memory
export SCR=/mnt/lustre/koa/scratch/$USER/$SLURM_JOBID
export USERSCR=${SCR}
mkdir -p $SCR
export currentdir=`pwd`

#------------------------------------------------------------------------------
# STEP5: Loop over every .inp in the submit directory -> ONE Slurm job
# *** Use with caution!!! Inputs whose .log already finished normally are ***
# *** skipped; any other existing .log will be overwritten.               ***
#------------------------------------------------------------------------------
for file in *.inp; do
  inp=`realpath $file`
  output=${inp%.inp}.log
  name=${inp%.inp}

  if [ -e "$output" ] && grep -q "EXECUTION OF GAMESS TERMINATED NORMALLY" $output; then
    echo "Skipping $file (finished log exists)"
    continue
  fi
  echo "Running $file"

  # GAMESS file setup (unique JOB name per input so files do not collide)
  base=`basename ${inp%.inp}`
  export JOB=JOB.${SLURM_JOBID}.${base}
  source $GMSPATH/gms-files.bash
  export INPUT=$USERSCR/${JOB}.F05
  export OUTPUT=$USERSCR/${JOB}.F06

  #----------------------------------------------------------------------------
  # STEP6: Copy input to scratch and run GAMESS there
  #----------------------------------------------------------------------------
  cp $inp $INPUT
  cd $SCR
  echo "srun --mpi=pmix -N $NNODES -n $NCPUS2 --ntasks-per-node=$PPN2 --export=ALL --cpu-bind verbose,cores \
    $GMSPATH/gamess.00.x >& $output"

  srun --mpi=pmix -N $NNODES -n $NCPUS2 --ntasks-per-node=$PPN2 --export=ALL --cpu-bind verbose,cores \
    $GMSPATH/gamess.00.x >& $output

  cd $currentdir

  #----------------------------------------------------------------------------
  # STEP7: Copy back result files if they exist, then clear this job's scratch
  #----------------------------------------------------------------------------
  # copy efp file
  EFP=$SCR/${JOB}.efp
  if [ -e "$EFP" ]; then
    cp $EFP ${name}.efp
  fi

  # copy dat file
  DAT=$SCR/${JOB}.dat
  if [ -e "$DAT" ]; then
    cp $DAT ${name}.dat
  fi

 #------------------------------------------------------------------------------
 # STEP8: Clean up scratch
 #------------------------------------------------------------------------------
  rm -f $SCR/${JOB}.*
  srun $GMSPATH/bin/my_ipcrm
done

