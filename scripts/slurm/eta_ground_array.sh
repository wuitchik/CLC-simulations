#!/bin/bash
#SBATCH --job-name=eta_array
#SBATCH --array=0-100
#SBATCH --ntasks=1
#SBATCH --time=2:00:00
#SBATCH --mem=4G
#SBATCH --output=/cluster/home/dwuitc01/CLC-simulations/scripts/slurm/logs/eta_%A_%a.out
#SBATCH --error=/cluster/home/dwuitc01/CLC-simulations/scripts/slurm/logs/eta_%A_%a.err

# Use cluster built SLiM
SLIM_PATH="$HOME/slim_build/SLiM/build/slim"

# Set variables
SEED=${SLURM_ARRAY_TASK_ID}
ETA=$(printf "%.2f" "$(echo "$SEED * 0.01" | bc)")
OUTDIR="/cluster/home/dwuitc01/CLC-simulations/data/raw/eta_marshall_comp_seasons_negCOV"
MAP_FILE="/cluster/home/dwuitc01/CLC-simulations/data/maps/solid_gray.png"
SLIM_SCRIPT="/cluster/home/dwuitc01/CLC-simulations/scripts/slim/eta_marshall_comp_seasons_negCOV.slim"

# Make sure output directory exists
mkdir -p "$OUTDIR"

# Run SLiM simulation
slim \
  -d SEED=$SEED \
  -d OUTDIR="'$OUTDIR'" \
  -d MAP_FILE="'$MAP_FILE'" \
  "$SLIM_SCRIPT"

