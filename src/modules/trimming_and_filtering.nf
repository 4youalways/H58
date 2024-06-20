process TRIMMOMATIC {

    container 'staphb/trimmomatic:0.39'

    input:
    tuple val(sample_id), path(reads)
    
    output:
    tuple val(sample_id), path("*_0{1,2}.trimmed.fastq.gz")
    
    script:
    """ 
    trimmomatic PE -threads 4 -phred33 ${reads} \
    ${sample_id}_01.trimmed.fastq.gz  ${sample_id}_01.trimmed_unpaired.fastq.gz \
    ${sample_id}_02.trimmed.fastq.gz  ${sample_id}_02.trimmed_unpaired.fastq.gz \
    ILLUMINACLIP:TruSeq3-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
    """
}
