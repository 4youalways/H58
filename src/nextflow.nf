nextflow.enable.dsl=2

params.ncbi_api_key = "c3861eef22d9a4d964e0b9667bab30d53008"
params.sample_sheet = '/Users/zuza/repos/H58/docs/isolate_metadata.csv'

params.reads = '/Users/zuza/repos/H58/outputs/fastp/**_{1,2}.fastq.gz'

// set output folders
params.outdir = '../outputs/'
params.mappings = '../outputs/mappings'


include { TRIM_LONG; FASTQC; FASTP; MAPPING } from './modules/bacteria_pipeline.nf'
//params.accession = ['ERR360832', 'ERR279139',  'ERR2602821', 'ERR2602832']

params.accession = ['ERR360832']

params.ref = '../docs/sequence.fasta'

/*
// snippet on how to access samplenames from a sample sheet
sample_id_ch = Channel
    .fromPath(params.sample_sheet)
    .splitCsv(header: true)
//    .collect()
//    .flatten()
    .map { row -> "${row.accession_number}" }
//    .view()
//    .flatten()
//    .view(row -> "${row.accession_number}")

/*
sample_id_ch
    .toString()
    .view()

*/
/*
println(sample_id_ch)
fastqc_ch = Channel
    .fromSRA("ERR984834", apiKey: params.ncbi_api_key)
//    .view()
//Channel.of("${sample_id_ch}").view()
// snipet how to access accession numbers on ncbi

*/

workflow {
/*
reads = 
//    Channel
    .fromSRA(params.accession, apiKey: params.ncbi_api_key)
    .view()
Channel.of(reads).view()
reference_ch =
    Channel.fromPath(params.ref)
//    .view()

//FASTQC(fastqc_ch)
//fastq = GET_READS(reads) //not working...the script passes the fileame instead of the full path

//trimmed = FASTP(reads)
//BWA_MEM(trimmed, BWA_INDEX(reference_ch))

*/




//GET_READS('ERR360832')

reads_ch = channel
            .fromFilePairs(params.reads)
ref_ch = channel
            .fromPath(params.ref)
//            .view()
MAPPING(reads_ch, ref_ch)
}
