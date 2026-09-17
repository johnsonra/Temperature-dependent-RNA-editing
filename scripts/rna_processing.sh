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
  IN="data/${SAMPLE}.fastq.gz"

  TRIMMED="intermediate/${SAMPLE}_trimmed.fastq.gz"

  SALMON_OUT="results/${SAMPLE}_quant"

  # Run fastp for QC and trimming
  echo "Running fastp..."
  fastp -i ${IN} \
        -o ${TRIMMED} \
        --html results/${SAMPLE}_fastp.html \
        --json results/${SAMPLE}_fastp.json \
        --thread 2

  # Run salmon quant on the trimmed reads
  echo "Running salmon quant..."
  salmon quant -i ${INDEX} -l A \
               -r ${TRIMMED} \
               -p 2 -o ${SALMON_OUT}

  echo "Sample ${SAMPLE} complete!"
done
