nextflow.enable.dsl=2

// QC of raw reads



process TRIM_LONG {
    tag "FILTLONG on $sample_id"
    publishDir "${params.trimed_reads}", mode: 'copy'

    input: 
    tuple val(sample_id), path('reads')

    output:
    tuple val(sample_id),  path("${sample_id}.fastq.gz")

    script:
    "filtlong --min_length 1000 --keep_percent 90 ${reads} | gzip > ${sample_id}.fastq.gz"
} 

process FASTQC {

    tag "FASTQC on $sample_id"
    publishDir "${params.fastqc}", mode: 'copy'

    input:
    //tuple val(sample_id), path(reads)
    tuple val(sample_id), path(read1), path(read2)

    output:
    path("fastqc_${sample_id}") 

    //fastqc -o fastqc_${sample_id} -f fastq -q $read1 $read2 ${pair[0]} ${pair[1]} -t 64
    script:
    """
    mkdir fastqc_${sample_id}
    fastqc -o fastqc_${sample_id} -f fastq -q $read1, $read2 -t 8
    """
}

process MULTIQC {
    publishDir "${params.outdir}/multiqc", mode:'copy'

    input:
    path('*')

    output:
    path('multiqc_report.html')

    script:
    """
    multiqc .
    """
}


process NANOPLOT {
    tag "NANOPLOT on $sample_id"
    publishDir "${params.outdir}", mode: 'copy'

    input:
    tuple val(sample_id), path(reads) 


    output:
    path "nanoplot/$sample_id"
 

    script :
    
    """
    mkdir -p nanoplot/$sample_id
    NanoPlot -t 2 --fastq $reads --maxlength 40000 --plots dot kde -o nanoplot/$sample_id -p $sample_id
    """
    
}

process FLYE {
    tag "FLYE on $sample_id"
    publishDir "${params.assemblies}", mode: 'copy'

    input:
    tuple val(sample_id), path(reads) 

    output:
    tuple val(sample_id), path("flye/$sample_id/assembly.fasta")
 
    script :
    """
    mkdir -p flye/$sample_id
    flye --nano-hq $reads --out-dir flye/$sample_id -i 3 -g 4.5m
    """
}

process MEDAKA_POLISH {
    tag "MEDAKA_POLISH on $sample_id"
    publishDir "${params.assemblies}", mode: 'copy'

    container 'ontresearch/medaka:latest'

    input:
    tuple val(sample_id), path('reads'), path('assembly')
    //path assembly 

    output:
    tuple val(sample_id), path("medaka/$sample_id")
 
    script :
    """
    mkdir -p medaka/$sample_id
    medaka_consensus -i ${reads} -d ${assembly} -o medaka/$sample_id -m r941_min_sup_g507
    """
}

process PROKKA {
    tag "PROKKA on $sample_id"
    publishDir "${params.outdir}", mode: 'copy'

    input:
    tuple val(sample_id), path('assembly') 

    output:
    path "prokka/$sample_id"
 
    script :
    """
    mkdir -p prokka/$sample_id
    prokka --outdir prokka/$sample_id --locustag STY --prefix $sample_id --usegenus --genus Salmonella --force --compliant $assembly
    """

}

process BWA_INDEX_MEM {
    tag "BWA_MEM on $sample_id"
    publishDir "${params.alignments}", mode: 'copy'

    input:
      //path 'assembly'
      tuple val(sample_id), path('read1'), path('read2'), path('assembly')
    
    output:
    tuple val(sample_id), path("*alignments_*.sam")

    script:
      """
    bwa index ${assembly}/consensus.fasta
    bwa mem -t 16 -a ${assembly}/consensus.fasta ${read1} > ${sample_id}_alignments_1.sam
    bwa mem -t 16 -a ${assembly}/consensus.fasta ${read2} > ${sample_id}_alignments_2.sam
      """
}



process POLYPOLISH {
    publishDir "${params.outdir}", mode: 'copy'

    input:
    tuple val(sample_id), path('alignments'), path('assembly')
    //path assembly 

    output:
    tuple val(sample_id), path("final_assembly/${sample_id}_polished.fasta")
 
    script :
    """
    mkdir final_assembly
    polypolish_insert_filter.py --in1 ${alignments[0]} --in2 ${alignments[1]} --out1 filtered_1.sam --out2 filtered_2.sam
    polypolish ${assembly}/consensus.fasta filtered_1.sam filtered_2.sam > final_assembly/${sample_id}_polished.fasta
    """

}

// 
process FASTP {
    publishDir "${params.outdir}", mode: 'copy'

    input:
    tuple val(sample_id), path(reads)

    output:
    tuple val(sample_id), path("fastp/${sample_id}_FP_1.fastq.gz"), path("fastp/${sample_id}_FP_2.fastq.gz")
    
 
    script :
    """
    mkdir fastp
    fastp --in1 ${reads[0]} --in2 ${reads[1]}  --out1 fastp/${sample_id}_FP_1.fastq.gz --out2 fastp/${sample_id}_FP_2.fastq.gz --cut_front --cut_tail --trim_poly_x --cut_mean_quality 30 --qualified_quality_phred 30 --unqualified_percent_limit 10 --length_required 50
    """
}

// running mykrobe on isolates

process MYKROBE_PREPARE{
    tag "Preparing Mykrobe"

    container 'staphb/mykrobe:0.12.1-mykrobe-2.0'

 
    script :
    """
    mykrobe panels update_metadata
    mykrobe panels update_species all
    """
}


process MYKROBE_PREDICT{
    tag "Predicting genotype for ${sample_id}"
    
    publishDir "${params.output}", mode: 'copy'
    container 'staphb/mykrobe:0.12.1-mykrobe-2.0'
    echo true
    
    input:
    tuple val(sample_id), path('reads')


    output:
    path "${sample_id}.json"
 
    script :
    """
    mykrobe predict --sample ${sample_id} --species typhi --format json --out ${sample_id}.json --seq ${reads[0]} ${reads[1]}
    
    """
}

// pangenome analysis
process ROARY{
    tag "Running roary on the assemblies"
    
    publishDir "${params.output}", mode: 'copy'
    container 'biocontainers/roary:v3.12.0dfsg-2-deb_cv1'
    debug true
    
    input:
    path 'gff'

    output:
    path "roary"
    path "pangenome*"
 
    script :
    """
    roary -e --mafft -p 8 -f roary $gff
    roary_plots.py --labels roary/mytree.newick roary/gene_presence_absence.csv 

    """
}

// snp calling and phylogenetics
process SNIPPY{
    tag "calling snps for ${sample_id}"
    
    publishDir "${params.output}", mode: 'copy'
    container 'staphb/snippy:latest'
    cpus 64
    debug true
    
    input:
    tuple val(sample_id), path('reads')


    output:
    path "${params.output}/${sample_id}"
 
    script :
    """
    snippy --cpus ${task.cpus} --outdir ${params.output}/${sample_id} --reference ${params.ref} --R1 ${reads[0]} --R2 ${reads[0]}
    
    """
}