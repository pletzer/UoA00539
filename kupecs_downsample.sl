#!/bin/bash 
#SBATCH --nodes=1
#SBATCH --tasks=1
#SBATCH --time=00:02:00
#SBATCH --cpus-per-task=12

module load matlab

for downsampleRate in 500 200 100; do
    echo "running with downsampleRate = $downsampleRate"
    time matlab -nodisplay -nosplash -singleCompThread -nojvm -r "downsampleRate=$downsampleRate; STEP_1_Processing_RS_v2_downsample; exit" >& log_$downsampleRate.txt
done
 
