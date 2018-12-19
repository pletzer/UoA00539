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

You'll need a RAW file, let's call it x.RAW, which contains EEG signal data (amplitudes vs time). Copy the RAW files to the `input/` directory. 

To run the script, type
```
matlab -nodisplay < STEP_1_Processing_RS_v2.m
```
This will produce x.xlsx. Open the file to see values for each measure (with some Nans for some false nearest neighbours). 


