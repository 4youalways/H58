#!/usr/bin/env nextflow
nextflow.enable.dsl=2

process BUSCO {
    tag "${sample}"
    
    container 'ezlabgva/busco:v5.8.0_cv1'

    input:
    tuple val(sample_id), path(file)

    output:
    path("${sample_id}")
    

    script:
    """
    busco -i ${file[1]} -l enterobacterales_odb10 -o ${sample_id} -m genome

    """
}


workflow ASSEMBLY_QC {
    take:
    ont_reads_ch

    main:
    BUSCO(ont_reads_ch)
}
