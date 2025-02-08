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
params.illumina_map = false


include { MAP_ONT } from './src/mapping.nf'
include { MAP_TO_REF } from './src/mapping.nf'
include { ASSEMBLY_QC } from './src/assembly_qc.nf'
include { ASSEMBLY } from './src/assembly.nf'

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

plasmid_accessions_ch = channel.fromPath("docs/h58_plasmid_accessions.txt")
    .splitCsv()
    .flatten()

downloaded_reads_ch = channel.fromFilePairs("outputs/reads/*_{1,2}.fastq.gz")

pHCM1_ch = channel.fromPath("docs/pHCM1.fasta")


// execute the ont mapping by default. when the flag --illumina_map is set, execute the illumina mapping

workflow ASSEMBLY_QC_WF {
    ASSEMBLY_QC(ont_reads_ch)
}

workflow ASSEMBLY_WF {
    ASSEMBLY(plasmid_accessions_ch)
    reads = ASSEMBLY.out.reads
    
    emit:
    reads
}


workflow COVERAGE_WF {
   // take:
   // plasmid_accessions_ch
    //pHCM1_ch

    main:
    if (params.illumina_map) {
    MAP_TO_REF(pHCM1_ch, downloaded_reads_ch)
    }
    else {
    MAP_ONT(ont_reads_ch)
}}

