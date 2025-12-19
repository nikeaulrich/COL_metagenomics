#!/bin/bash
#SBATCH -c 24  # Number of Cores per Task
#SBATCH --mem=180G  # Requested Memory
#SBATCH -p cpu  # Partition
#SBATCH -t 24:00:00  # Job time limit
#SBATCH --mail-type=ALL
#SBATCH -o /work/pi_sarah_gignouxwolfsohn_uml_edu/nikea/COL/mapping/dlab/slurm-mapping-%j.out  # %j = job ID

module load conda/latest
conda activate anvio-8

SAMPLENAME="dlab"
READSPATH="/work/pi_sarah_gignouxwolfsohn_uml_edu/nikea/COL/assembly/${SAMPLENAME}/repaired"
CONTIGPATH="/work/pi_sarah_gignouxwolfsohn_uml_edu/nikea/COL/assembly/${SAMPLENAME}/megahit_assembly"
CONTIGFILE="$SAMPLENAME".contigs.fa
WORKPATH="/work/pi_sarah_gignouxwolfsohn_uml_edu/nikea/COL/mapping/${SAMPLENAME}"
mkdir -p "$WORKPATH"
XTRAFILES="/project/pi_sarah_gignouxwolfsohn_uml_edu/nikea/COL_files/mapping/${SAMPLENAME}"
mkdir -p "$XTRAFILES"
LISTPATH="/work/pi_sarah_gignouxwolfsohn_uml_edu/nikea/COL/"
SAMPLELIST="032024_dlab_sampleids.txt" 
 
anvi-script-reformat-fasta $CONTIGPATH/$CONTIGFILE -o $WORKPATH/"${SAMPLENAME}.contigs-fixed.fsa" -l 1000 --simplify-names --report-file $WORKPATH/contig-rename-report-txt

#fixes deflines (filters contigs and reformats so naming is cleaner)
#filtering seq length 1000bp...need to play around with filtering based on bp length
#deflines = sequence definition line. comes directly before its associated sequence in a fasta file


FIXEDCON="${SAMPLENAME}.contigs-fixed.fsa"

cd $WORKPATH
#this builds an index of your contigs, which only needs to happen once
bowtie2-build $FIXEDCON "$SAMPLENAME"_contigs
# will not accept path before contigs file - must be in the correct dir 

while IFS= read -r SAMPLEID; do
    #align reads to your contigs and collects that in a .sam file
    bowtie2 --threads 11 -x "$SAMPLENAME"_contigs -1 $READSPATH/"${SAMPLEID}"_host_removed_R1.tagged_filter_ready.fastq.gz -2 $READSPATH/"${SAMPLEID}"_host_removed_R2.tagged_filter_ready.fastq.gz -S $XTRAFILES/"${SAMPLEID}".sam
    #make sure to point it to the index not the FIXEDCON file (-x parameter)
    
    #converts your sam file to a bam file, but its neither sorted nor indexed, so we use an Anvi'O script to do so:
    samtools view -F 4 -b -S $XTRAFILES/"${SAMPLEID}".sam -o $WORKPATH/"${SAMPLEID}"-RAW.bam
   
    #index and sort your bam file
    anvi-init-bam $WORKPATH/"${SAMPLEID}"-RAW.bam -o $WORKPATH/"${SAMPLEID}".bam
    
    rm $WORKPATH/"${SAMPLEID}"-RAW.bam
done < "$LISTPATH/${SAMPLELIST}"
echo "Mapping success!"

#JOB ID:
#bash script: nikea/COL/bash_scripts/Col_mapping.sh