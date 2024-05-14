#!/bin/bash

set -eu

REF='../docs/sequence.fasta'

reads='../outputs/fastp/ERR2602832*'
vcf='../outputs/mappings/ERR2602832*'

#bwa index ${REF}

#bwa mem ${REF} ${reads} > ../outputs/alignments/mapping.sam

#samtools view -b ../outputs/alignments/mapping.sam > ../outputs/alignments/mapping.bam

#samtools sort ../outputs/alignments/mapping.bam > ../outputs/alignments/id.bam

#samtools index ../outputs/alignments/id.bam

#bcftools mpileup -Ou -f $REF ../outputs/alignments/id.bam | \
#bcftools call -v -c --ploidy 1 -Ob --skip-variants indels > ../outputs/alignments/id.bcf

#bcftools index ../outputs/alignments/id.bcf

#bcftools view -H ../outputs/alignments/id.bcf -Oz > ../outputs/alignments/id.bcf.gz

#tabix ../outputs/alignments/id.bcf.gz

#head ../outputs/alignments/id.bcf
bcftools index ${vcf}
bcftools consensus -f ${REF} ${vcf} -o {sample_id}.fasta

head {sample_id}.fasta
