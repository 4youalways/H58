process SNIPPY{
    tag "calling snps for ${sample_id}"
    container 'staphb/snippy:4.6.0-SC2'
    cpus 8
    maxForks 5 // change this parameter as needed depending on the amount of resources needed


    input:
    tuple val(sample_id), path(reads)
    each path('ref')


    output:
    //tuple val(sample_id), path("${sample_id}")
    path("${sample_id}")

    script :
    """
    snippy --cpus ${task.cpus} --outdir ${sample_id} --reference ${ref} --R1 ${reads[0]} --R2 ${reads[0]} --prefix ${sample_id}
    
    """
}

process SNIPPY_CORE{
    tag "calling snps for ${sample_id}"
    container 'staphb/snippy:4.6.0-SC2'
    cpus 8
    
    input:
    //tuple val(sample_id), path(snps)
    path(snps)
    path(ref)

    output:
    path "core.*"
 
    script :

    //mkdir samples
    //cp -r ${snps} samples/
    """
    snippy-core --ref ${ref} --prefix core ${snps}*
    """
}

process SNP_SITES{
    tag "calling snps for ${sample_id}"
    container 'staphb/snippy:4.6.0-SC2'
    cpus 8
    
    input:
    path full_aln
    
    output:
    path "phylo.aln", emit: phylo
    path "constant.txt", emit: constant
 
    script :
    """
    snp-sites -b -c -o ref_phylo.aln ${full_aln}/core.full.aln
    sed -e '/Reference/,+1d' ref_phylo.aln > phylo.aln
    snp-sites -C ${full_aln}/core.full.aln > constant.txt
    """
}
