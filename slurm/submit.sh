#!/bin/bash

# ENVS="walker-walk;cheetah-run;ball_in_cup-catch;cartpole-swingup;finger-spin;reacher-easy"
ENVS="antmaze-umaze-v0;antmaze-umaze-diverse-v0;antmaze-medium-diverse-v0;antmaze-medium-play-v0;antmaze-large-diverse-v0;antmaze-large-play-v0;maze2d-umaze-v1;maze2d-medium-v1;maze2d-large-v1"

mkdir logs/out/ -p
mkdir logs/err/ -p

arrENVS=(${ENVS//;/ })
NUM_ENVS=${#arrENVS[@]}

sbatch --export=ENVS=$ENVS,SEEDS=$SEEDS,OUTDIR=$OUTDIR,ERRDIR=$ERRDIR --array=1-${NUM_ENVS}%16 sbatch.sh