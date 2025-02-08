#!/usr/bin nextflow

nextflow.enable.dsl=2

params.short_reads = "./samples/ERR279139_{1,2}.fastq.gz"
params.output = "profiles"

process MYKROBE_PREPARE{
    tag "Preparing Mykrobe"

    container 'staphb/mykrobe:0.12.1-mykrobe-2.0'

    output:
    path "status.txt", emit: status
 
    script :
    """
    mykrobe panels update_metadata
    mykrobe panels update_species all
    echo "done" > status.txt
    """
}


process MYKROBE_PREDICT{
    tag "Predicting genotype for ${sample_id}"
    
    publishDir "${params.output}", mode: 'copy'
    container 'staphb/mykrobe:0.12.1-mykrobe-2.0'
    
    input:
    path file
    tuple val(sample_id), path('reads')


    output:
    path "${sample_id}.json"
 
    script :
    """
    mykrobe predict --sample ${sample_id} --species typhi --format json --out ${sample_id}.json --seq ${reads[0]} ${reads[1]}
    
    """
}

workflow {

reads_ch = channel.fromFilePairs(params.short_reads)

MYKROBE_PREPARE()

MYKROBE_PREDICT(MYKROBE_PREPARE.out.status, reads_ch)

}
