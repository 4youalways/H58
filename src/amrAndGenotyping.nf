#!/usr/bin/env nextflow
nextflow.enable.dsl=2

include { ARIBA_PREPARE } from './modules/ariba.nf'
include { ARIBA_RUN } from './modules/ariba.nf'

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

workflow microbe{
    take:
    reads

    main:

    MYKROBE_PREPARE()

    MYKROBE_PREDICT(MYKROBE_PREPARE.out.status, reads)

}


workflow ariba{
    take:
    reads

    main:

    ARIBA_PREPARE()

    ARIBA_RUN(ARIBA_PREPARE.out.argannot, reads)

}
