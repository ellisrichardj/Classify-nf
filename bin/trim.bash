#!/bin/bash

# trim adapters and low quality bases from fastq data
# Removes the adapters which are added during the lab processing and and any low quality data

pair_id=$1
dependpath=$2

java -jar $dependpath/Trimmomatic-0.38/trimmomatic-0.38.jar PE -threads 2 -phred33 ${pair_id}_*_R1_*.fastq.gz ${pair_id}_*_R2_*.fastq.gz ${pair_id}_trim_R1.fastq ${pair_id}_fail1.fastq ${pair_id}_trim_R2.fastq ${pair_id}_fail2.fastq ILLUMINACLIP:$adapters:2:30:10 SLIDINGWINDOW:10:20 MINLEN:36
# java -jar /usr/local/bin/trimmomatic.jar PE -threads 2 -phred33 ${pair_id}_*_R1_*.fastq.gz ${pair_id}_*_R2_*.fastq.gz  ${pair_id}_trim_R1.fastq ${pair_id}_fail1.fastq ${pair_id}_trim_R2.fastq ${pair_id}_fail2.fastq ILLUMINACLIP:$adapters:2:30:10 SLIDINGWINDOW:10:20 MINLEN:36
rm ${pair_id}_fail1.fastq
rm ${pair_id}_fail2.fastq
gzip ${pair_id}_trim_R1.fastq &
gzip ${pair_id}_trim_R2.fastq &
wait