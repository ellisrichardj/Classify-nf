#!/bin/bash

# Bracken parses the output which is then sorted to generate a top 20 list of species
# Presence / absence of M.bovis is also determined by parsing Bracken output

pair_id=$1
kraken2db=$2

~/Tools/Kraken2/kraken2 --threads 2 --db $kraken2db --output - --report ${pair_id}_kraken2.tab --paired ${pair_id}_trim_R1.fastq.gz  ${pair_id}_trim_R2.fastq.gz 

~/Tools/Bracken-2.6.0/bracken -d $kraken2db -r 150 -l S -t 10 -i ${pair_id}_kraken2.tab -o ${pair_id}_bracken.out
sed 1d ${pair_id}_bracken.out | sort -t $'\t' -k7,7 -nr > ${pair_id}_brackensort.tab

rm `readlink ${pair_id}_trim_R1.fastq.gz`
rm `readlink ${pair_id}_trim_R2.fastq.gz`