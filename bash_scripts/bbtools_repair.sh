#!/bin/bash
#SBATCH -c 24  # Number of Cores per Task
#SBATCH --mem=180G  # Requested Memory
#SBATCH -p cpu  # Partition
#SBATCH -t 48:00:00  # Job time limit
#SBATCH --mail-type=ALL
#SBATCH -o /work/pi_sarah_gignouxwolfsohn_uml_edu/nikea/COL/assembly/pstr/slurm-repair-%j.out  # %j = job ID

module load conda/latest
conda activate assembly


SAMPLENAME="pstr"
SAMPLELIST="032024_pstr_sampleids.txt" 
READSPATH="/work/pi_sarah_gignouxwolfsohn_uml_edu/nikea/COL/assembly/${SAMPLENAME}/final_reads_filtered"
LISTPATH="/work/pi_sarah_gignouxwolfsohn_uml_edu/nikea/COL/"
OUTDIR="/work/pi_sarah_gignouxwolfsohn_uml_edu/nikea/COL/assembly/${SAMPLENAME}/repaired"
mkdir -p "$OUTDIR"

#Lets try this! Using repair.sh script from:https://jgi.doe.gov/data-and-tools/software-tools/bbtools/bb-tools-user-guide/repair-guide/
while IFS= read -r SAMPLEID; do

repair.sh in1=$READSPATH/"${SAMPLEID}"_host_removed_R1.tagged_filter.fastq.gz in2=$READSPATH/"${SAMPLEID}"_host_removed_R2.tagged_filter.fastq.gz \
out1=$OUTDIR/"${SAMPLEID}"_host_removed_R1.tagged_filter_ready.fastq.gz out2=$OUTDIR/"${SAMPLEID}"_host_removed_R2.tagged_filter_ready.fastq.gz \
outs=$OUTDIR/"${SAMPLEID}"singletons.fq repair;
 if [ $? -eq 0 ]; then
        echo "repair completed successfully for sample: $SAMPLEID"
    else
        echo "repair encountered an error for sample: $SAMPLEID"
        exit 1
    fi
done < "$LISTPATH/${SAMPLELIST}"

conda deactivate

# JOB-ID: 
# bash script file name: nikea/COL/bash_scripts/bbtools_repair.sh