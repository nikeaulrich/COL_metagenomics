#!/bin/bash
#SBATCH -c 24  # Number of Cores per Task
#SBATCH --mem=50G  # Requested Memory
#SBATCH -p cpu  # Partition
#SBATCH -t 24:00:00  # Job time limit
#SBATCH --mail-type=ALL
#SBATCH -o /work/pi_sarah_gignouxwolfsohn_uml_edu/nikea/COL/binning/pstr/slurm-dastool_checkm-%j.out  # %j = job ID  # %j = job ID


module load conda/latest
conda activate binning

# Set parameters
SAMPLENAME="pstr"
BINPATH="/work/pi_sarah_gignouxwolfsohn_uml_edu/nikea/COL/binning/${SAMPLENAME}/${SAMPLENAME}_DASTool_bins"

#Run CheckM
checkm lineage_wf -x fa -t 3 $BINPATH $BINPATH/CheckM_stats

# JOB-ID:
# bash script file name: /nikea/COL/bash_scripts/Col_das_tool_checkM.sh