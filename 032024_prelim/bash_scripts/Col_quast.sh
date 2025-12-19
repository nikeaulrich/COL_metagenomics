#!/bin/bash
#SBATCH -c 24  # Number of Cores per Task
#SBATCH --mem=50G  # Requested Memory
#SBATCH -p cpu  # Partition
#SBATCH -t 24:00:00  # Job time limit
#SBATCH --mail-type=ALL
#SBATCH -o /work/pi_sarah_gignouxwolfsohn_uml_edu/nikea/COL/assembly/dlab/slurm-metaquast-%j.out  # %j = job ID

module load conda/latest
conda activate assembly

SAMPLENAME="dlab"
WORKDIR="/work/pi_sarah_gignouxwolfsohn_uml_edu/nikea/COL/assembly/${SAMPLENAME}/megahit_assembly"
OUTDIR="/work/pi_sarah_gignouxwolfsohn_uml_edu/nikea/COL/assembly/${SAMPLENAME}"

metaquast "$WORKDIR"/"$SAMPLENAME".contigs.fa -t 12 -o $OUTDIR/quast_output

conda deactivate
# bash script file name: nikea/COL/bash_scripts/Col_quast.sh