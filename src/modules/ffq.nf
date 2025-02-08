process ffq {
    conda 'bioconda::ffq'
    
    maxForks 3
    
    input:
        val(accession)

    output:
        tuple val(accession), path("*_1.fastq.gz"), path("*_2.fastq.gz")
        
    script:
        """
        ffq --ftp ${accession} | grep -Eo '"url": "[^"]*"' | grep -o '"[^"]*"\$' | xargs -n 1 curl -O -s \
        --retry 5 --retry-all-errors --continue-at -
        
        """
}
