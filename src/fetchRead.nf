#!/usr/bin/env nextflow
nextflow.enable.dsl=2

include { ffq } from './modules/ffq.nf'


workflow downloadReads {

    take:
    accession_ch

    main:

    ffq(accession_ch)

    emit:

    reads = ffq.out
}