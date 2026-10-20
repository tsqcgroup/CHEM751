# CHEM751
## Module 10: H2 dissociation and Spin Contamination

In this module, you will learn about
 * using shell scripts to prepare many input files, submit them in one batch, and extract data from the log files.
 * RHF vs. UHF for bond dissociation, and spin contamination (<S^2>).

Link to [worksheet](https://docs.google.com/document/d/1fW1POJZPtMuoDOt5kFzOk-T5VIv-w1EQO7juNt8OO48/edit?usp=sharing)

Link to [shell script practice](https://docs.google.com/document/d/1e_Q2Sqfcoy-oVMbs2QJ4P8j_KpK8hM39zBE6Lp0euZg/edit?usp=sharing)

Helpful [GAMESS manual](https://github.com/tsqcgroup/CHEM751/blob/main/gamess_manual.txt)

### Files in this module
| File | What it does |
|------|--------------|
| `make_H2input.sh` | Writes a template input and makes one GAMESS input per H-H distance in a folder named after the method (`UHF/` or `RHF/`). |
| `subgms_batch.sh` | Slurm script that runs every `*.inp` in the submit directory, one after another, in a single job: `sbatch subgms_batch.sh` |
| `extract_E_S2.sh` | Collects the final energy (and <S^2>) from each log file into `H2_<method>.csv`. |

Each script has `TODO` lines for you to complete.

### Workflow
1. Make the inputs (set `method=UHF` or `method=RHF` at the top of the script):
   ```
   bash make_H2input.sh
   ```
2. Submit all inputs in the folder as **one** Slurm job (the script loops over every `*.inp` in the directory you submit from), for example:
   ```
   cd UHF
   sbatch ../subgms_batch.sh
   squeue -u $USER
   ```
   Each `X.inp` produces `X.log` in the same folder. Inputs that already have a log ending with `EXECUTION OF GAMESS TERMINATED NORMALLY` are skipped, so you can resubmit to rerun only failed/unfinished ones. If you have many inputs, increase the `#SBATCH -t` time limit.
3. When the jobs finish, extract the data (run inside the folder with the log files):
   ```
   bash ../extract_E_S2.sh
   ```
4. Repeat for the other method, then plot E vs. R and <S^2> vs. R for RHF and UHF.
