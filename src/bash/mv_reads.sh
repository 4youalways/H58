#!/bin/bash

samples=(1017142 BKQU3X A58390 BKQT8S)
sample_dir="./data"
new_dir="./data/ont"

for sample in ${samples[@]}; do
    echo "Processing sample $sample"
    reads="${sample_dir}/${sample}"

    for read in  ${reads}_*/fastq*; do
    new_name="./data/ont/${sample}_0.fastq.gz"
    cp $read $new_name
    echo "Copied $read to $new_name"
    echo
    echo
    echo "||-------------------------------------------------------||"
    echo
    echo
    done
done
