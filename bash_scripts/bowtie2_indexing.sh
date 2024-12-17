#!/bin/bash
#SBATCH -c 24  # Number of Cores per Task
#SBATCH --mem=50G  # Requested Memory
#SBATCH -p cpu  # Partition
#SBATCH -t 24:00:00  # Job time limit
#SBATCH --mail-type=ALL
#SBATCH -o /project/pi_sarah_gignouxwolfsohn_uml_edu/Reference_genomes/symbionts/slurm-index-%j.out  # %j = job ID

module load conda/latest
conda activate assembly

#build a bowtie2 index 
bowtie2-build --threads 20 /project/pi_sarah_gignouxwolfsohn_uml_edu/Reference_genomes/symbionts/Genomes/GCA_963969995.1/GCA_963969995.1_Durusdinium_trenchii_SCF082.fna /project/pi_sarah_gignouxwolfsohn_uml_edu/Reference_genomes/symbionts/indexed/GCA_963969995.1_index

#bowtie2-build /project/pi_sarah_gignouxwolfsohn_uml_edu/Reference_genomes/symbionts/Genomes/GCA_947184155.2/GCA_947184155.2_Cgoreaui_SCF055-01_v2.1_genomic.fna /project/pi_sarah_gignouxwolfsohn_uml_edu/Reference_genomes/symbionts/indexed/GCA_947184155.2_index

conda deactivate
