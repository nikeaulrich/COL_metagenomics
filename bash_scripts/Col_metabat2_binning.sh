#!/bin/bash
#SBATCH -c 24  # Number of Cores per Task
#SBATCH --mem=50G  # Requested Memory
#SBATCH -p cpu  # Partition
#SBATCH -t 24:00:00  # Job time limit
#SBATCH --mail-type=ALL
#SBATCH -o /work/pi_sarah_gignouxwolfsohn_uml_edu/nikea/COL/binning/dlab/slurm-metabat2binning-%j.out  # %j = job ID  # %j = job ID

module load conda/latest
conda activate binning

#set parameters for binning:
SAMPLENAME="dlab"
BINDIR="/work/pi_sarah_gignouxwolfsohn_uml_edu/nikea/COL/binning/${SAMPLENAME}/MetaBAT2_bins"
mkdir -p $BINDIR
CONTIGPATH="/work/pi_sarah_gignouxwolfsohn_uml_edu/nikea/COL/mapping/${SAMPLENAME}"
CONTIGFILE="${SAMPLENAME}.contigs-fixed.fsa"

#create depth file for MetaBat2
jgi_summarize_bam_contig_depths --outputDepth $BINDIR/MetaBAT2_depth.txt $CONTIGPATH/*.bam

#MetaBat2 script with verbose output, minimum length (m)(has to be >=1500) and no min bin size 
metabat2 -i $CONTIGPATH/$CONTIGFILE -a $BINDIR/MetaBAT2_depth.txt \
-o $BINDIR/metabat2 -m 1500

# MetaBAT2 (v2:2.17)
# default parameters:
#-m [ --minContig ] arg (=2500)    Minimum size of a contig for binning (should be >=1500).
#  --maxP arg (=95)                  Percentage of 'good' contigs considered for binning decided by connection
#                                    among contigs. The greater, the more sensitive.
#  --minS arg (=60)                  Minimum score of a edge for binning (should be between 1 and 99). The 
#                                    greater, the more specific.
#  --maxEdges arg (=200)             Maximum number of edges per node. The greater, the more sensitive.
#  --pTNF arg (=0)                   TNF probability cutoff for building TNF graph. Use it to skip the 
#                                    preparation step. (0: auto).
#  -x [ --minCV ] arg (=1)           Minimum mean coverage of a contig in each library for binning.
#  --minCVSum arg (=1)               Minimum total effective mean coverage of a contig (sum of depth over 
#                                    minCV) for binning.
#  -s [ --minClsSize ] arg (=200000) Minimum size of a bin as the output.
#  -t [ --numThreads ] arg (=0)      Number of threads to use (0: use all cores).

#this runs CheckM immediately after and puts the results alongside your bins
checkm lineage_wf -x fa -t 3 $BINDIR/ $BINDIR/bins-stats

# JOB-ID:
# bash script file name: /nikea/COL/bash_scripts/Col_metabat2_binning.sh