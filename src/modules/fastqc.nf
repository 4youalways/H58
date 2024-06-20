
process FASTQC {

    tag "$sample_id"
    container 'staphb/fastqc:0.12.1'

    input:
    tuple val(sample_id), path(reads)
    
    output:
    tuple val(sample_id), path("*.html"), emit: html
    tuple val(sample_id), path("*.zip"), emit: zip
    

    script:
    """
    #!/bin/bash
    fastqc --threads $task.cpus -o . ${reads}
    """
}
