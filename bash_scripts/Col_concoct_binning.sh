#!/bin/bash
#SBATCH -c 24  # Number of Cores per Task
#SBATCH --mem=50G  # Requested Memory
#SBATCH -p cpu  # Partition
#SBATCH -t 24:00:00  # Job time limit
#SBATCH --mail-type=ALL
#SBATCH -o /work/pi_sarah_gignouxwolfsohn_uml_edu/nikea/COL/binning/dlab/slurm-concoctbinning-%j.out  # %j = job ID  # %j = job ID

module load conda/latest
conda activate concoct_env

#set parameters
SAMPLENAME="dlab"
BINPATH="/work/pi_sarah_gignouxwolfsohn_uml_edu/nikea/COL/binning/${SAMPLENAME}/CONCOCT_bins"
mkdir -p $BINPATH
CONTIGPATH="/work/pi_sarah_gignouxwolfsohn_uml_edu/nikea/COL/mapping/${SAMPLENAME}"
CONTIGFILE="${SAMPLENAME}.contigs-fixed.fsa"
BAMPATH="/work/pi_sarah_gignouxwolfsohn_uml_edu/nikea/COL/mapping/${SAMPLENAME}"

TEMPDIR="/project/pi_sarah_gignouxwolfsohn_uml_edu/nikea/COL_files/binning/concoct_${SAMPLENAME}_temp"
mkdir -p $TEMPDIR

#creates the CONCOCT depth file
#this part cuts up the contigs into 10kb pieces for CONCOCT to use 
cut_up_fasta.py $CONTIGPATH/$CONTIGFILE -c 10000 -o 0 --merge_last -b $BINPATH/${SAMPLENAME}_contigs_cut.bed > $BINPATH/${SAMPLENAME}_contigs_cut.fa

#estimate contig coverage
concoct_coverage_table.py $BINPATH/${SAMPLENAME}_contigs_cut.bed $BAMPATH/*.bam > $BINPATH/coverage_table_${SAMPLENAME}.tsv || { echo 'Exit code 2: failed to create coverage file, exiting.' && exit; }

#run CONCOCT
concoct --composition_file $BINPATH/${SAMPLENAME}_contigs_cut.fa --coverage_file $BINPATH/coverage_table_${SAMPLENAME}.tsv -t 3 -b $TEMPDIR || { echo 'Exit code 3: CONCOCT failed to run, exiting.' && exit; }
merge_cutup_clustering.py $TEMPDIR/clustering_gt1000.csv > $TEMPDIR/${SAMPLENAME}_clustering_merged.csv || { echo 'Exit code 4: failed to merge clusters, exiting.' && exit; }
extract_fasta_bins.py $CONTIGPATH/$CONTIGFILE $TEMPDIR/${SAMPLENAME}_clustering_merged.csv --output_path $BINPATH || { echo 'Exit code 5: Bins were not extracted, exiting.' && exit; }

# Checkm is in binning env so switching environments 
conda deactivate

conda activate binning

#this runs CheckM immediately after and puts the results alongside your bins
checkm lineage_wf -x fa -t 3 $BINPATH  $BINPATH/CheckM_stats

# JOB-ID:
# bash script file name: /nikea/COL/bash_scripts/Col_concoct_binning.sh