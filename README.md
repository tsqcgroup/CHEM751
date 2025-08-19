# CHEM751
## To use git command

you need to work on the interactive session by using the following command
 
 ```srun -A chem751 -p chem751 -N 1 -c 2 --mem=5g -t 60 --pty /bin/bash ```
 
 - for the first time downloading the repo to your directory
	1. load the following modules

		``` module purge
		module load compiler/GCC/12.2.0 devel/CMake/3.24.3-GCCcore-12.2.0 
		module load mpi/OpenMPI/4.1.4-GCC-12.2.0 
		module load lang/Python/3.10.8-GCCcore-12.2.0
		module load tools/git tools/tcsh
  		```
  
	2. clone the repo 
 
 		``` git clone git@github.com:tsatta/CHEM751.git ```

 - If you already have the repo,
   
		cd CHEM751/ENV_modules
		source env_gcc.sh
		source git-completion.bash 

 - Some important git commands are in ```doc-git.txt```

## To run the calculation

You can copy the submission script from ```SCRIPT``` directory to your working directory.
 - if you use the interactive section, please use ```subgms_local.sh```
   and run the calculation by the following command
   
   ```./subgms_local.sh file_name.inp```
 - if you want to use the queuing system, please use ```subgms_mpi.sh```
   and run the calculation by the following command
   
   ```sbatch subgms_mpi.sh file_name.inp```
   
   checking status with ```squeue --me```

 After the job is done or not on the queue anymore, 
 
 ```grep 'TERMINATED' file_name.log```
 
 You should get 'TERMINATED NORMALLY'. 
 Otherwise, open the log file and see if it provides you any information to fix 
 your input and resubmit

## NOTE

 **NOTE: GAMESS was originally written in Fortran 77. And many parts of the codes,
   particularly routines for reading input, are still F77.
   You will need a blank space in the first column in the input. 
   For example,
   
```
 $contrl runtyp=energy mplevl=2 $end
 $system mwords=100 memddi=1000 $end
 $basis gbasis=n31 ngauss=6 $end
 $data
 title of input
 C1
 ...
 $end
```
