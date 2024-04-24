#!/usr/bin/env nextflow

params.reads = "/Users/liboxuan/Desktop/gt/biol7210/wrokflow2/SRR3215024/*_{1,2}.fastq.gz"

process FastQC_PreTrim {
    tag "${pair_id}"
    publishDir "results/FastQC_PreTrim", mode: 'copy'
    input:
        tuple val(pair_id), path(read_files)
    output:
        path "FastQC_PreTrim_${pair_id}"
    script:
    """
    mkdir -p FastQC_PreTrim_${pair_id}
    fastqc -o FastQC_PreTrim_${pair_id} ${read_files}
    """
}

process FastP {
    tag "${pair_id}"
    publishDir "results/FastP", mode: 'copy'
    input:
        tuple val(pair_id), path(read_files)
    output:
        tuple val(pair_id), path("cleaned_${pair_id}_R1.fastq.gz"), 
path("cleaned_${pair_id}_R2.fastq.gz")
    script:
    """
    fastp --in1 ${read_files[0]} --in2 ${read_files[1]} \
          --out1 cleaned_${pair_id}_R1.fastq.gz \
          --out2 cleaned_${pair_id}_R2.fastq.gz
    """
}

process FastQC_PostTrim {
    tag "${pair_id}"
    publishDir "results/FastQC_PostTrim", mode: 'copy'
    input:
        tuple val(pair_id), path(read1), path(read2)
    output:
        path "FastQC_PostTrim_${pair_id}"
    script:
    """
    mkdir -p FastQC_PostTrim_${pair_id}
    fastqc -o FastQC_PostTrim_${pair_id} ${read1} ${read2}
    """
}

process SKESA_Assembly {
    tag "${pair_id}"
    publishDir "results/SKESA", mode: 'copy'
    input:
        tuple val(pair_id), path(cleaned_reads)
    output:
        path "${pair_id}.fasta"
    script:
    """
    skesa --fastq ${cleaned_reads.join(' ')} --contigs_out ${pair_id}.fasta
    """
}

process QUAST {
    tag "${pair_id}"
    publishDir "results/QUAST", mode: 'copy'
    input:
        path assembled_fasta
    output:
        path "${assembled_fasta.baseName}_quast/"
    script:
    """
    mkdir -p ${assembled_fasta.baseName}_quast
    quast ${assembled_fasta} -o ${assembled_fasta.baseName}_quast
    """
}

process MLST {
    tag "${pair_id}"
    publishDir "results/MLST", mode: 'copy'
    input:
        path assembled_fasta
    output:
        path "${assembled_fasta.baseName}_mlst/"
    script:
    """
    mkdir -p ${assembled_fasta.baseName}_mlst
    mlst ${assembled_fasta} > ${assembled_fasta.baseName}_mlst/${assembled_fasta.baseName}_mlst.txt
    """
}


workflow {
    read_pairs_ch = Channel.fromFilePairs(params.reads, size: 2, checkIfExists: true)

    FastQC_PreTrim(read_pairs_ch)
        .view { "FastQC_PreTrim output: $it" }

    fastp_ch = FastP(read_pairs_ch)
    fastp_ch
        .view { "FastP output: $it" }

    FastQC_PostTrim(fastp_ch)
        .view { "FastQC_PostTrim output: $it" }

    skesa_ch = SKESA_Assembly(fastp_ch)
    skesa_ch
        .view { "SKESA_Assembly output: $it" }

    quast_ch = skesa_ch.map { it -> it }
    mlst_ch = skesa_ch.map { it -> it }

    QUAST(quast_ch)
        .view { "QUAST output: $it" }

    MLST(mlst_ch)
        .view { "MLST output: $it" }
}

