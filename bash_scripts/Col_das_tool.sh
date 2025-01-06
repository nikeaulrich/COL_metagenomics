#!/bin/bash
#SBATCH -c 24  # Number of Cores per Task
#SBATCH --mem=50G  # Requested Memory
#SBATCH -p cpu  # Partition
#SBATCH -t 24:00:00  # Job time limit
#SBATCH --mail-type=ALL
#SBATCH -o /work/pi_sarah_gignouxwolfsohn_uml_edu/nikea/COL/binning/ofav/slurm-das_tool-%j.out  # %j = job ID  # %j = job ID

module load conda/latest
conda activate binning

# Set parameters
SAMPLENAME="ofav"
CONCOCTPATH="/work/pi_sarah_gignouxwolfsohn_uml_edu/nikea/COL/binning/${SAMPLENAME}/concoct.contigs2bin.tsv"  
METABATPATH="/work/pi_sarah_gignouxwolfsohn_uml_edu/nikea/COL/binning/${SAMPLENAME}/metabat2.contigs2bin.tsv"
CONTIGPATH="/work/pi_sarah_gignouxwolfsohn_uml_edu/nikea/COL/mapping/${SAMPLENAME}"
CONTIGFILE="${SAMPLENAME}.contigs-fixed.fsa"
OUTDIR="/work/pi_sarah_gignouxwolfsohn_uml_edu/nikea/COL/binning/${SAMPLENAME}"

#Run DAS Tool
DAS_Tool -i $CONCOCTPATH,$METABATPATH \
-l concoct,metabat2 \
-c $CONTIGPATH/$CONTIGFILE \
-t 11 \
--write_bin_evals \
--write_bins \
-o $OUTDIR/"${SAMPLENAME}"

# -i input list: tab seperated table of contigs-bins 
#--score_threshold default is 0.5

# JOB-ID:
# bash script file name: /nikea/COL/bash_scripts/Col_das_tool.sh