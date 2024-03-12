nextflow.enable.dsl=2

params.ncbi_api_key = "c3861eef22d9a4d964e0b9667bab30d53008"
params.sample_sheet = '/Users/zuza/repos/H58/docs/isolate_metadata.csv'

include {TRIM_LONG} from './modules/bacteria_pipeline.nf'




// snippet on how to access samplenames from a sample sheet
sample_id_ch = Channel
    .fromPath(params.sample_sheet)
    .splitCsv(header: true)
 //   .view(row -> "${row.accession_number}")


// snipet how to access accession numbers on ncbi
workflow {
Channel
    .fromSRA(sample_id_ch, apiKey: params.ncbi_api_key)
    .view()
}