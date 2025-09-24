# CHEM751
## Module 8: Electron Correlation

At the beginning of the semester, we talked about the limit of HF and electron correlation problems. This module will demonstrate the electron correction effects on electronic structures and energetic property.

Note that we will use ORCA for all calculations today. Please attention to the choice of submission script.  

Link to [worksheet](https://docs.google.com/document/d/1FHbp_aiTa6IglcElF8E2RG9ceTfkDdrQMZ62hJzwcfA/edit?usp=sharing)  


Helpful [ORCA manual](https://orca-manual.mpi-muelheim.mpg.de/contents/quickstartguide/hellowater.html)  

### Optional
 - If you prepare all inputs at once and want to submit the calculations more efficiently, you can use [runorca_loop.sh](./runorca_loop.sh) for submission  
   To use  
   ``` sbatch runorca_loop.sh ```  

   The script will list all inputs in the directory and start the calculations for all of them automatically.    
 - Writing bash script is sometimes very helpful to extract information, especially for large data. Here, I provide two bash scripts to extract the energy and bond distance, extractE.sh anbd extractbond.sh, from ORCA outputs. The printed format can be easily put on spreadsheet. To use, for example, ``` bash extractE.sh ```  


  * Note: If you plan to use my scripts, you should learn how the scripts work by yourself.*
