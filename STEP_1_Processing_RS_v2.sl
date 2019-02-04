#!/bin/bash
#
# may need to adjust
#SBATCH --time=00:05:00

#SBATCH --job-name=step1RS
#SBATCH --error=step1RS-%A.error
#SBATCH --output=step1RS-%A.output
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH --mem=1G
#SBATCH --hint=nomultithread

DOWNSAMPLE_RATE=50

# change to "module load MATLAB" on mahuika
module load matlab
srun matlab -nodisplay -nojvm -nosplash -r "downsampleRate=$DOWNSAMPLE_RATE; STEP_1_Processing_RS_v2; exit"

