# UoA00539
Fractal Analysis of ASD

## Prerequisites

You'll need to have

 * parfor toolbox installed
 * eeglab toolbox version `14_1_2b` installed. Follow the instructions at https://sccn.ucsd.edu/eeglab/download.php to install eeglab. The scripts expect the `eeglab14_1_2b` to exist at the same level as `STEP_1_Processing_RS_v2.m`. You can create a symbolic link
```
ln -s <directory-to-eeglab14_1_2b> eeglab14_1_2b
``` 
if this is not the case.

## How to run the resting state (RS) script 

You'll need a RAW file, let's call it x.RAW, which contains EEG signal data (amplitudes vs time). Copy the RAW files to the `./` directory. 

To run the script, type
```
matlab -nodisplay -nojvm -nosplash < STEP_1_Processing_RS_v2.m
```
This will produce x.xlsx. Open the file to see values for each measure (with some Nans for some false nearest neighbours)
and print out 
```
check nansum:208.0924
```

## Adjusting the sample rate

The run time will increase significantly with smaller `downsampleRate` values. The default value is 500. Use any value >= 1 with 1 meaning
no downsampling. To set `downsampleRate` to 200, for instance, type command:
```
 matlab -nodisplay -nojvm -nosplash -r "downsampleRate=200; STEP_1_Processing_RS_v2; exit"
``` 

## Running under Slurm 

```
srun --hint=nomultithread --time=01:00:00 --cpus-per-task=10 --ntasks=1 --mem=16G \
matlab -nodisplay -nojvm -nosplash -r "downsampleRate=20; STEP_1_Processing_RS_v2; exit"
```
where `mem` is the total memory. You can use the `sacct` command to infer the maximum memory used by a job. You want to set `mem` fairly tightly as this will let you slip into the queue faster. 
 
