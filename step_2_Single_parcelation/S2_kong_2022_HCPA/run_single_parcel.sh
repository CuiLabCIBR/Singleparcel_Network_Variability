#!/bin/bash
#SBATCH -p lab_fat
#SBATCH --ntasks=1 # Run a single serial task
#SBATCH --cpus-per-task=5
#SBATCH -e job.%j.log # Standard error
#SBATCH -o job.%j.pro_out.txt # Standard output
#SBATCH --job-name=gradient_pre
#SBATCH --mail-user wuguowei@cibr.ac.cn
#SBATCH --mail-type=END
module load MATLAB/R2019a
cd /GPFS/cuizaixu_lab_permanent/wuguowei/python_code/repeat_code/Single_parcellation_FC_Variability/step_2_Single_parcelation/S2_kong_2022_HCPA
matlab -singleCompThread -nodisplay -nosplash -r $1