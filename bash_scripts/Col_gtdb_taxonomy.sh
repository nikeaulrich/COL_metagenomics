#!/bin/bash
#SBATCH -c 24  # Number of Cores per Task
#SBATCH --mem=150G  # Requested Memory
#SBATCH -p cpu  # Partition
#SBATCH -t 24:00:00  # Job time limit
#SBATCH --mail-type=ALL
#SBATCH -o /work/pi_sarah_gignouxwolfsohn_uml_edu/nikea/COL/taxonomy/dlab/slurm-gtdb_taxonomy-%j.out  # %j = job ID  # %j = job ID

module load conda/latest
conda activate /scratch3/workspace/nikea_ulrich_uml_edu-gtdb/envs/taxonomy

# Set parameters
SAMPLENAME="dlab"
BINPATH="/work/pi_sarah_gignouxwolfsohn_uml_edu/nikea/COL/binning/${SAMPLENAME}/${SAMPLENAME}_DASTool_bins"
OUTDIR="/work/pi_sarah_gignouxwolfsohn_uml_edu/nikea/COL/taxonomy/${SAMPLENAME}"
mkdir -p $OUTDIR

#Run gtdb-tk
gtdbtk classify_wf --genome_dir $BINPATH --out_dir $OUTDIR/gtdb_out

#This will process all genomes in the directory <my_genomes> using both bacterial and archaeal marker sets and place the results in <output_dir>.
#Genomes must be in FASTA format (gzip with the extension .gz is acceptable)

# JOB-ID:
# bash script file name: /nikea/COL/bash_scripts/Col_gtdb_taxonomy.sh