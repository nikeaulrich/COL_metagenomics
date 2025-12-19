#!/bin/bash
#SBATCH -c 24  # Number of Cores per Task
#SBATCH --mem=180G  # Requested Memory
#SBATCH -p cpu  # Partition
#SBATCH -t 48:00:00  # Job time limit
#SBATCH --mail-type=ALL
#SBATCH -o /work/pi_sarah_gignouxwolfsohn_uml_edu/nikea/COL/assembly/pstr/slurm-spades-assembly-%j.out  # %j = job ID

module load conda/latest
conda activate spades_env

SAMPLENAME="pstr"
SAMPLELIST="032024_pstr_sampleids.txt" 
LISTPATH="/work/pi_sarah_gignouxwolfsohn_uml_edu/nikea/COL/"
WORKDIR="/work/pi_sarah_gignouxwolfsohn_uml_edu/nikea/COL/assembly/${SAMPLENAME}"
OUTDIR="/project/pi_sarah_gignouxwolfsohn_uml_edu/nikea/COL_files/assembly/${SAMPLENAME}"
#mkdir -p "$OUTDIR"

# 4)ASSEMBLE reads into contigs with metaspades
spades.py --meta \
-1 "$WORKDIR"/"$SAMPLENAME"_reads_R1_ALL.fastq.gz \
-2 "$WORKDIR"/"$SAMPLENAME"_reads_R2_ALL.fastq.gz \
-o $OUTDIR/metaspades_assembly 

conda deactivate
echo "Metaspades assembly completed!"

# JOB-ID: 
# bash script file name: nikea/COL/bash_scripts/Col_spades_assemble.sh