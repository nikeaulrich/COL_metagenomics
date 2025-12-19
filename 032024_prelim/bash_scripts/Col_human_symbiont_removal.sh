#!/bin/bash
#SBATCH -c 24  # Number of Cores per Task
#SBATCH --mem=180G  # Requested Memory
#SBATCH -p cpu  # Partition
#SBATCH -t 24:00:00  # Job time limit
#SBATCH --mail-type=ALL
#SBATCH -o /work/pi_sarah_gignouxwolfsohn_uml_edu/nikea/COL/assembly/pstr/slurm-HSremoval-%j.out  # %j = job ID

module load conda/latest
conda activate assembly

# 2)remove symbiont and human seqs using fastq screen 
SAMPLENAME="pstr"
SAMPLELIST="032024_pstr_sampleids.txt" 
READSPATH="/work/pi_sarah_gignouxwolfsohn_uml_edu/nikea/COL/assembly/${SAMPLENAME}/host_removed"
LISTPATH="/work/pi_sarah_gignouxwolfsohn_uml_edu/nikea/COL/"

FASTQSCREEN='/home/nikea_ulrich_uml_edu/.conda/envs/assembly/share/fastq-screen-0.16.0-0'
OUTPUTDIR="/work/pi_sarah_gignouxwolfsohn_uml_edu/nikea/COL/assembly/${SAMPLENAME}/final_reads_filtered"

mkdir -p "$OUTPUTDIR"
if [ $? -ne 0 ]; then
    echo "Error: Failed to create output directory $OUTPUTDIR"
    exit 1
fi

while IFS= read -r SAMPLEID; do
$FASTQSCREEN/fastq_screen --nohits --aligner bowtie2 --conf $FASTQSCREEN/fastq_screen.conf --outdir $OUTPUTDIR \
$READSPATH/"${SAMPLEID}"_host_removed_R1.fastq.gz $READSPATH/"${SAMPLEID}"_host_removed_R2.fastq.gz;
 if [ $? -eq 0 ]; then
        echo "fastq_screen completed successfully for sample: $SAMPLEID"
    else
        echo "fastq_screen encountered an error for sample: $SAMPLEID"
        exit 1
    fi
# --nohits = output reads do not map to any genomes
done < "$LISTPATH/${SAMPLELIST}"
conda deactivate
echo "Symbiont, host removal: All samples processed successfully."

# JOB-ID:
# bash script file name: nikea/COL/bash_scripts/Col_human_symiont_removal.sh