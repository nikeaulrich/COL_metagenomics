#!/bin/bash
#SBATCH -c 24  # Number of Cores per Task
#SBATCH --mem=50G  # Requested Memory
#SBATCH -p cpu  # Partition
#SBATCH -t 24:00:00  # Job time limit
#SBATCH --mail-type=ALL
#SBATCH -o /work/pi_sarah_gignouxwolfsohn_uml_edu/nikea/COL/anvio/ofav/slurm-anvio-%j.out  # %j = job ID

module load conda/latest
conda activate anvio-8

#Contig database from assembled genomes. stores information related to your sequences: positions of open reading frames, k-mer frequencies for each contig, functional and taxonomic annotation of genes, etc.
#set parameters:
SAMPLENAME="ofav"
CONTIGPATH="/work/pi_sarah_gignouxwolfsohn_uml_edu/nikea/COL/mapping/${SAMPLENAME}"
CONTIGFILE="${SAMPLENAME}.contigs-fixed.fsa"
BAMPATH="/work/pi_sarah_gignouxwolfsohn_uml_edu/nikea/COL/mapping/${SAMPLENAME}"
DBPATH="/work/pi_sarah_gignouxwolfsohn_uml_edu/nikea/COL/anvio/${SAMPLENAME}"
mkdir -p "$DBPATH"
OUTDIR="/work/pi_sarah_gignouxwolfsohn_uml_edu/nikea/COL/anvio/${SAMPLENAME}/profiles"
mkdir -p "$OUTDIR"
 

#from merged, fixed contig fasta file created in previous step..need for downstream analysis
#default k-mer frequency is 4
anvi-gen-contigs-database -f $CONTIGPATH/$CONTIGFILE --project-name $SAMPLENAME -o $DBPATH/$SAMPLENAME.contigs.db  

#integrate HMMs into the database:
anvi-run-hmms -c $DBPATH/$SAMPLENAME.contigs.db --num-threads 6

#this runs NCBI COGs against your contigs.db, integrating gene functions
anvi-run-ncbi-cogs -c $DBPATH/$SAMPLENAME.contigs.db -T 4

#ADD KEGG-KOFAM
anvi-run-kegg-kofams -c $DBPATH/$SAMPLENAME.contigs.db \
                     -T 4 #these are the threads that Anvi'O is allowed to use
#ADD CONTIG STATS
anvi-display-contigs-stats $DBPATH/$SAMPLENAME.contigs.db --report-as-text --as-markdown -o $DBPATH/anvio_stats.txt

cd $BAMPATH

#create sample profiles
#make sure sample list is in the folder w/ BAM files
for f in $(cat 032024_ofav_sampleids.txt) 
do
	echo "processing $f file" 
anvi-profile -c $DBPATH/$SAMPLENAME.contigs.db  \
			-i "$f".bam \
            --min-percent-identity 95 \
            --min-contig-length 1500 \
            --sample-name "ofav"_"$f" \
            --output-dir $OUTDIR/"$f"
done
#Will fail if output dir already exists. sample name can't start with an number, hence the species name in front
#keep parameters consistent in order to merge to larger profile 
echo "Anvio profiling: All samples sucessfully completed!"

#merge single sample profiles to one profile
anvi-merge $OUTDIR/*/PROFILE.db \
			-c $DBPATH/$SAMPLENAME.contigs.db \
            -o $OUTDIR/"$SAMPLENAME"_profile_merged

echo "Anvio profiling: All profiles merged"
conda deactivate

# JOB-ID:
# bash script file name: /nikea/COL/bash_scripts/Col_anvio.sh