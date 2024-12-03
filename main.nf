#!/usr/bin/env nextflow

/*
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

 this was the functional workflow. modifying the script to run using entry points
workflow {
    downloadReads(accession_ch)
    microbe(downloadReads.out)
    ariba(downloadReads.out)
}
*/

include { MAP_ONT } from './src/mapping.nf'
include { ASSEMBLY_QC } from './src/assembly_qc.nf'

ont_reads_ch = channel.fromPath("docs/illumina_ont_sheet.csv", checkIfExists:true)
    .splitCsv( header: true )
    .map {
        row ->
        meta = row.ont_id
        [meta, [
            file(row.ont),
            file(row.assembly)
        ]]
    }
    //.view()

workflow COVERAGE_WF {
    MAP_ONT(ont_reads_ch)
}

workflow ASSEMBLY_QC_WF {
    ASSEMBLY_QC(ont_reads_ch)
}
