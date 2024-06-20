nextflow.enable.dsl=2




/*
include { FASTQC as before_trim } from './src/modules/fastqc.nf' 
include { FASTQC as after_trim }  from './src/modules/fastqc.nf'
include { TRIMMOMATIC } from './src/modules/trimming_and_filtering.nf'
*/
include { SNIPPY } from './src/modules/variant_calling.nf'
include { SNIPPY_CORE  } from './src/modules/variant_calling.nf'
include { SNP_SITES } from './src/modules/variant_calling.nf'
include { IQTREE } from './src/modules/iqtree.nf'



workflow  {
    reads_ch = channel.fromPath(params.sample_sheet, checkIfExists:true)
    .splitCsv(header: true)
    .map {
        row ->
        meta = row.sample_name
        [meta, [
            file(row.read_1),
            file(row.read_2)
        ]]
    }

    ref_ch = channel.fromPath(params.ref, checkIfExists:true)
    snps = SNIPPY(reads_ch, ref_ch).collect() // variant calling step
    full_aln = SNIPPY_CORE(snps, ref_ch) // generating fasta alignment
    phylo = SNP_SITES(full_aln)   
    IQTREE(SNP_SITES.out.phylo, SNP_SITES.out.constant)

}
