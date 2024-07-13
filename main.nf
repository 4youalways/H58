#!/usr/bin/env nextflow

//---------------------------------------
// include the genomic workflow
//---------------------------------------


include { downloadReads } from './src/fetchRead.nf'
include { microbe } from './src/amrAndGenotyping.nf'
include { ariba } from './src/amrAndGenotyping.nf'


//---------------------------------------------------------------
// Param Checking 
//---------------------------------------------------------------

accession_ch = Channel
    .fromPath(params.sraAccession)
    .splitCsv( header: true )

//--------------------------------------
// Process the workflow
//-------------------------------------

workflow {
    downloadReads(accession_ch)
    microbe(downloadReads.out)
    ariba(downloadReads.out)
}