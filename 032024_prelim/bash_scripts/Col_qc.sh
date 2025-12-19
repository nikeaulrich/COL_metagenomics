#!/bin/bash
#SBATCH -c 24  # Number of Cores per Task
#SBATCH --mem=50G  # Requested Memory
#SBATCH -p cpu  # Partition
#SBATCH -t 24:00:00  # Job time limit
#SBATCH --mail-type=ALL
#SBATCH -o /work/pi_sarah_gignouxwolfsohn_uml_edu/nikea/COL/slurm-qc-%j.out  # %j = job ID

module load conda/latest

# Run qc with trim galore and fastqc
conda activate qc

# Define the paths and variables
FILEPATH='/project/pi_sarah_gignouxwolfsohn_uml_edu/nikea/COL_files/10162024fastq_data'
OUTPUT_RESULTS='/work/pi_sarah_gignouxwolfsohn_uml_edu/nikea/COL/trimmed'
NSLOTS=4  

#create filename if not already created
ls $FILEPATH -1 | sed 's/_R.*_001.fastq.gz//' | uniq | cat > $OUTPUT_RESULTS/'032024_sampleids.txt'

SAMPLE_NAMES_FILE="/work/pi_sarah_gignouxwolfsohn_uml_edu/nikea/COL/trimmed/032024_sampleids.txt"

# Check if the file exists
if [ ! -e "$SAMPLE_NAMES_FILE" ]; then
    echo "Error: $SAMPLE_NAMES_FILE does not exist."
    exit 1
fi

# Read each line from the file and perform actions
while IFS= read -r sample_id; do
    # Form the full file names
    input_r1="$FILEPATH/${sample_id}_R1_001.fastq.gz"
    input_r2="$FILEPATH/${sample_id}_R2_001.fastq.gz"
    
    # Ensure the input files exist before running the tools
    if [ ! -e "$input_r1" ] || [ ! -e "$input_r2" ]; then
        echo "Error: Input files do not exist for sample $sample_id"
        continue
    fi

    # Run trim_galore
    trim_galore -j "$NSLOTS" -q 20 --phred33 --length 20 --paired $input_r1 $input_r2 --fastqc -o $OUTPUT_RESULTS


done < "$SAMPLE_NAMES_FILE"

# bash script file name: COL_qc
# JOB-ID: 
#trimmed read seqs in folder: /work/pi_sarah_gignouxwolfsohn_uml_edu/nikea/COL/trimmed