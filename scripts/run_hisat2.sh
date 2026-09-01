#!/usr/bin/env bash
set -euo pipefail

PROJECT="/mnt/d/OSCC_RNAseq"

SAMPLE="$1"

INDEX="$PROJECT/04_alignment/reference/hisat2_index/GRCh38_gencode_v50"
R1="$PROJECT/03_trimmed/fastq/${SAMPLE}_1.trimmed.fastq.gz"
R2="$PROJECT/03_trimmed/fastq/${SAMPLE}_2.trimmed.fastq.gz"

BAM="$PROJECT/04_alignment/bam/${SAMPLE}.sorted.bam"
LOG="$PROJECT/04_alignment/logs/${SAMPLE}_hisat2.log"

echo "========================================"
echo "Sample: $SAMPLE"
echo "Started: $(date)"
echo "========================================"

hisat2 \
    -p 8 \
    -x "$INDEX" \
    -1 "$R1" \
    -2 "$R2" \
    2> "$LOG" \
| samtools sort \
    -@ 8 \
    -o "$BAM" \
    -

samtools index -@ 8 "$BAM"

echo
echo "Alignment completed: $SAMPLE"
echo "BAM: $BAM"
echo "Index: ${BAM}.bai"
echo "Finished: $(date)"
echo
echo "HISAT2 summary:"
cat "$LOG"
