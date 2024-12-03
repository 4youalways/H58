#!/usr/bin/env nextflow
nextflow.enable.dsl=2

process MAPPING {
    tag "${sample}"
    conda '/Users/zuza/miniconda3/envs/mapping'

    input:
    tuple val(sample_id), path(file)

    output:
    path("${sample_id}.coverage")
    path("${sample_id}.bam"), emit: bam

    script:
    """
    minimap2 -ax map-ont ${file[1]} ${file[0]} > aln.sam 
    samtools view -bS aln.sam > aln.bam
    samtools sort aln.bam -o ${sample_id}.bam
    samtools index ${sample_id}.bam
    samtools coverage ${sample_id}.bam > ${sample_id}.coverage
    """
}

process COVERAGE {
    tag "${sample}"
    conda '/Users/zuza/miniconda3/envs/mapping'
    input:
    path(bam_files)

    output:
    path('coverage.txt')

    script:
    """
    samtools coverage ${bam_files} > coverage.txt
    """
}


workflow MAP_ONT{
    take:
    ont_reads_ch

    main:
    MAPPING(ont_reads_ch)
    COVERAGE(MAPPING.out.bam.collect())
}
