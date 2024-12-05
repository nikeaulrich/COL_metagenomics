#!/bin/bash
#SBATCH -c 24  # Number of Cores per Task
#SBATCH --mem=180G  # Requested Memory
#SBATCH -p cpu  # Partition
#SBATCH -t 24:00:00  # Job time limit
#SBATCH --mail-type=ALL
#SBATCH -o /work/pi_sarah_gignouxwolfsohn_uml_edu/nikea/COL/slurm-removal-%j.out  # %j = job ID

module load conda/latest
conda activate anvio-8

# 1)remove host from sample reads
#set general parameters:
SAMPLENAME="mcav"
SAMPLELIST="032024_mcav_sampleids.txt"
RAWREADSPATH='/work/pi_sarah_gignouxwolfsohn_uml_edu/nikea/COL/trimmed/mcav'
READSPATH="/work/pi_sarah_gignouxwolfsohn_uml_edu/nikea/COL/assembly/${SAMPLENAME}/host_removed"
mkdir -p $READSPATH
EXTRAFILESPATH="/project/pi_sarah_gignouxwolfsohn_uml_edu/nikea/COL_files/host_removal/${SAMPLENAME}"
mkdir -p $EXTRAFILESPATH
LISTPATH="/work/pi_sarah_gignouxwolfsohn_uml_edu/nikea/COL/"
#set step parameters 
GENOME="Mcav"
INPUTPATH="/project/pi_sarah_gignouxwolfsohn_uml_edu/Reference_genomes/${GENOME}_genome"
INDEX="${GENOME}_DB"

#build a bowtie2 index from a known genome
# **using ofav since pstr is more closely related to ofav than mcav - (was only built for histat so need to redo for bowtie)
#bowtie2-build $INPUTPATH/GCF_002042975.1_ofav_dov_v1_genomic.fna $INPUTPATH/"$INDEX"

#loop through samples
while IFS= read -r SAMPLEID; do
#re-align reads back to the index
bowtie2 -p 8 -x $INPUTPATH/$INDEX -1 "$RAWREADSPATH"/"${SAMPLEID}_R1_001_val_1.fq.gz" -2 "$RAWREADSPATH"/"${SAMPLEID}_R2_001_val_2.fq.gz" -S $EXTRAFILESPATH/"${SAMPLEID}"_mapped_and_unmapped.sam
#convert sam file from bowtie to a bam file for processing
samtools view -bS $EXTRAFILESPATH/"${SAMPLEID}"_mapped_and_unmapped.sam > $EXTRAFILESPATH/"${SAMPLEID}"_mapped_and_unmapped.bam
#extract only the reads of which both do not match against the host genome
samtools view -b -f 12 -F 256 $EXTRAFILESPATH/"${SAMPLEID}"_mapped_and_unmapped.bam > $EXTRAFILESPATH/"${SAMPLEID}"_bothReadsUnmapped.bam
# sorts the file so both mates are together and then extracts them back as .fastq files
samtools sort -n -m 5G -@ 2 $EXTRAFILESPATH/"${SAMPLEID}"_bothReadsUnmapped.bam -o $EXTRAFILESPATH/"${SAMPLEID}"_bothReadsUnmapped_sorted.bam
samtools fastq -c 6 -@ 8 $EXTRAFILESPATH/"${SAMPLEID}"_bothReadsUnmapped_sorted.bam \
    -1 $READSPATH/"${SAMPLEID}"_host_removed_R1.fastq.gz \
    -2 $READSPATH/"${SAMPLEID}"_host_removed_R2.fastq.gz \
    -0 /dev/null -s /dev/null -n
 if [ $? -eq 0 ]; then
        echo "host removal completed successfully for sample: $SAMPLEID"
    else
        echo "host removal encountered an error for sample: $SAMPLEID"
        exit 1  
    fi
done < "$LISTPATH/${SAMPLELIST}"
conda deactivate
echo "Host removal: All samples processed successfully."

# JOB-ID:
# bash script file name: nikea/COL/Col_host_removal.sh