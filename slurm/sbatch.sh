#!/bin/bash
#SBATCH --job-name=sac
#SBATCH --open-mode=append
#SBATCH --output=logs/out/%x_%j.txt
#SBATCH --error=logs/err/%x_%j.txt
#SBATCH --time=24:00:00
#SBATCH --mem=24G
#SBATCH --cpus-per-task=4
#SBATCH --gres=gpu"1
#SBATCH --account=co_rail
#SBATCH --partition=savio2_gpu
#SBATCH --qos=savio_lowprio


ENV_ID=$((SLURM_ARRAY_TASK_ID-1))

arrENVS=(${ENVS//;/ })

ENV_NAME=${arrENVS[$ENV_ID]}

module load gnu-parallel

echo $ENV_NAME

run_singularity ()
{
    singularity exec --nv --writable-tmpfs -B /usr/lib64 -B /var/lib/dcv-gl --overlay $SCRATCH/singularity/overlay-50G-10M.ext3:ro $SCRATCH/singularity/cuda11.4-cudnn8-devel-ubuntu18.04.sif /bin/bash -c "
    source ~/.bashrc
    XLA_PYTHON_CLIENT_PREALLOCATE=false python -m ../JaxCQL/conservative_sac_main.py --env=$2 \
                    --logging.output_dir './experiment_output' \
                    --logging.online
    "
}
export -f run_singularity

parallel --delay 20 --linebuffer -j 5 run_singularity {} $ENV_NAME ::: 1 2 3 4 5