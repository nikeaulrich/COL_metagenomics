#!/bin/bash
#SBATCH -c 24  # Number of Cores per Task
#SBATCH --mem=180G  # Requested Memory
#SBATCH -p cpu  # Partition
#SBATCH -t 24:00:00  # Job time limit
#SBATCH --mail-type=ALL
#SBATCH -o /work/pi_sarah_gignouxwolfsohn_uml_edu/nikea/COL/assembly/pstr/slurm-assembly-%j.out  # %j = job ID

module load conda/latest
conda activate assembly

SAMPLENAME="pstr"
SAMPLELIST="032024_pstr_sampleids.txt" 
LISTPATH="/work/pi_sarah_gignouxwolfsohn_uml_edu/nikea/COL/"
WORKDIR="/work/pi_sarah_gignouxwolfsohn_uml_edu/nikea/COL/assembly/${SAMPLENAME}"

# 4)ASSEMBLE reads into contigs (contiguous sequence - joins them together based on read overlap, and ensures there are no gaps
megahit --presets meta-large \
-1 "$WORKDIR"/"$SAMPLENAME"_reads_R1_ALL.fastq.gz \
-2 "$WORKDIR"/"$SAMPLENAME"_reads_R2_ALL.fastq.gz \
--keep-tmp-files \
-o $WORKDIR/megahit_assembly --out-prefix $SAMPLENAME \
#--continue
#this one has to make the directory; will fail if it already exists

conda deactivate
echo "Assembly completed!"

# JOB-ID: 
# bash script file name: nikea/COL/bash_scripts/Col_assemble.sh