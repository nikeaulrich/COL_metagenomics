#!/bin/bash
#SBATCH -c 24  # Number of Cores per Task
#SBATCH --mem=180G  # Requested Memory
#SBATCH -p cpu  # Partition
#SBATCH -t 24:00:00  # Job time limit
#SBATCH --mail-type=ALL
#SBATCH -o /work/pi_sarah_gignouxwolfsohn_uml_edu/nikea/COL/assembly/pstr/slurm-cat-%j.out  # %j = job ID

module load conda/latest
conda activate assembly

SAMPLENAME="pstr"
SAMPLELIST="032024_pstr_sampleids.txt" 
READSPATH="/work/pi_sarah_gignouxwolfsohn_uml_edu/nikea/COL/assembly/${SAMPLENAME}/repaired"
LISTPATH="/work/pi_sarah_gignouxwolfsohn_uml_edu/nikea/COL/"
WORKDIR="/work/pi_sarah_gignouxwolfsohn_uml_edu/nikea/COL/assembly/${SAMPLENAME}"

# 3)CONCATETATE all f and r seqs into single file (1 for f, 1 for r)
# Read the sample IDs from the file
while IFS= read -r SAMPLEID; do
    # Construct the file paths for forward and reverse reads
    FORWARD_READ="$READSPATH/${SAMPLEID}_host_removed_R1.tagged_filter_ready.fastq.gz"
    REVERSE_READ="$READSPATH/${SAMPLEID}_host_removed_R2.tagged_filter_ready.fastq.gz"

    # Check if the files exist before concatenating
    if [ -e "$FORWARD_READ" ]; then
        cat "$FORWARD_READ" >> "$WORKDIR/${SAMPLENAME}_reads_R1_ALL.fastq.gz"
    else
        echo "Forward read file not found for sample $SAMPLEID"
    fi

    if [ -e "$REVERSE_READ" ]; then
        cat "$REVERSE_READ" >> "$WORKDIR/${SAMPLENAME}_reads_R2_ALL.fastq.gz"
    else
        echo "Reverse read file not found for sample $SAMPLEID"
    fi
done < "$LISTPATH/032024_pstr_sampleids"

conda deactivate
echo "Concatenation completed!"

# JOB-ID: 
# bash script file name: nikea/COL/bash_scripts/Col_concat.sh