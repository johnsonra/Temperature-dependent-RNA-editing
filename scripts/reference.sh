#!/bin/bash

# download reference
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/001/194/135/GCF_001194135.2_ASM119413v2/GCF_001194135.2_ASM119413v2_rna.fna.gz
gunzip GCF_001194135.2_ASM119413v2_rna.fna.gz
mv GCF_001194135* Octopus_bimaculoides_2_ASM119413v2_rna.fna

# index
salmon index -t Octopus_bimaculoides_2_ASM119413v2_rna.fna -i Octopus_bimaculoides_2_ASM119413v2_index

mv Octopus_bimaculoides* ref/.