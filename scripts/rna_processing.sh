#!/bin/bash
# run this in the main project directory with the samples you want to run in `samples.txt`
# for example, to run ERR458494, that should be the only sample in the file

# scripts/process_rna.sh

INDEX="ref/Octopus_bimaculoides_index"

# get an array of all samples to be processed
mapfile -t all_samples < "samples.txt"

for SAMPLE in "${all_samples[@]}"; do

  echo "Processing sample: ${SAMPLE}"

  # Define input and output paths based on directory structure
  IN1="data/${SAMPLE}_1.fastq.gz"
  IN2="data/${SAMPLE}_2.fastq.gz"

  TRIMMED1="intermediate/${SAMPLE}_1_trimmed.fastq.gz"
  TRIMMED2="intermediate/${SAMPLE}_2_trimmed.fastq.gz"

  SALMON_OUT="results/${SAMPLE}_quant"

  # Run fastp for QC and trimming
  echo "Running fastp..."
  fastp -i ${IN1} -I ${IN2} \
        -o ${TRIMMED1} -O ${TRIMMED2}\
        --html results/${SAMPLE}_fastp.html \
        --json results/${SAMPLE}_fastp.json \
        --thread 2

  # Run salmon quant on the trimmed reads
  echo "Running salmon quant..."
  salmon quant -i ${INDEX} -l A \
               -1 ${TRIMMED1} -2 ${TRIMMED2} \
               -p 2 -o ${SALMON_OUT}

  echo "Sample ${SAMPLE} complete!"
done
