process ffq {
    conda 'bioconda::ffq'
    
    maxForks 3
    
    input:
        tuple val(accession)

    output:
        tuple val(accession), path("*fastq.gz")

    script:
        """
        ffq --ftp ${accession} | grep -Eo '"url": "[^"]*"' | grep -o '"[^"]*"\$' | xargs -n 1 curl -O -s
        
        """
}