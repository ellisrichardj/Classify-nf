#!/bin/bash

# Bracken parses the output which is then sorted to generate a top 20 list of species
# Presence / absence of M.bovis is also determined by parsing Bracken output

pair_id=$1

$dependPath/Kraken2/kraken2 --threads 2 --quick $params.lowmem --db $kraken2db --output - --report ${pair_id}_"$outcome"_kraken2.tab --paired ${pair_id}_trim_R1.fastq  ${pair_id}_trim_R2.fastq 

# HACK: (AF) Ignore Bracken errors. Better to handle output from Kraken and have unit tests, 
# but easier let the pipeline pass while we are setting up validation tests.. 
# set +e

$dependPath/Bracken2.6.0/bracken -d $kraken2db -r 150 -l S -t 10 -i ${pair_id}_"$outcome"_kraken2.tab -o ${pair_id}_"$outcome"_bracken.out
sed 1d ${pair_id}_"$outcome"_bracken.out | sort -t $'t' -k7,7 -nr > ${pair_id}_"$outcome"_brackensort.tab

# HACK: see above
# set -e

else
echo "ID not required"
fi
rm `readlink ${pair_id}_trim_R1.fastq`
rm `readlink ${pair_id}_trim_R2.fastq`