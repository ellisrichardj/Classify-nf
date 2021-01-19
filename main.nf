#!/usr/bin/env nextflow

/* Default parameters */
params.lowmem = ""
params.reads = "$PWD/*_{S*_R1,S*_R2}*.fastq.gz"
params.outdir = "$PWD"
dependpath = file(params.dependPath)
kraken2db = file(params.kraken2db)

Channel
    .fromFilePairs( params.reads, flat: true )
    .ifEmpty { error "Cannot find any reads matching: ${params.reads}" }
	.set { read_pairs } 
	read_pairs.into { read_pairs; raw_reads }

/* trim adapters and low quality bases from fastq data
Removes the adapters which are added during the lab processing and and any low quality data */
process Trim {
	errorStrategy 'finish'
    tag "$pair_id"

	maxForks 2

	input:
	set pair_id, file("${pair_id}_*_R1_*.fastq.gz"), file("${pair_id}_*_R2_*.fastq.gz") from read_pairs

	output:
	set pair_id, file("${pair_id}_trim_R1.fastq"), file("${pair_id}_trim_R2.fastq") into trim_read_pairs
	
	"""
	trim.bash ${pair_id}
	"""
}

process Classify{
	errorStrategy 'finish'
    tag "$pair_id"

	//publishDir "$params.outdir/Results_${params.DataDir}_${params.today}/NonBovID", mode: 'copy', pattern: '*.tab'

	maxForks 1

	input:
	set pair_id, file("${pair_id}_trim_R1.fastq"), file("${pair_id}_trim_R2.fastq") from trim_read_pairs

	output:
	set pair_id, file("${pair_id}_brackensort.tab"), file("${pair_id}_kraken2.tab")  optional true into IDnonbovis
	
	"""
	classify.bash $pair_id $kraken2db
	"""
}
