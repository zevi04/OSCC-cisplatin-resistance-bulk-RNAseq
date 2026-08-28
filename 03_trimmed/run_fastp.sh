#!/bin/bash

RAW="/mnt/d/OSCC_RNAseq/01_raw_fastq"
OUT="/mnt/d/OSCC_RNAseq/03_trimmed/fastq"
REPORT="/mnt/d/OSCC_RNAseq/03_trimmed/reports"

mkdir -p "$OUT" "$REPORT"

for SAMPLE in \
    ERR4703472 \
    ERR4703473 \
    ERR4703474 \
    ERR4703475 \
    ERR4703476 \
    ERR4703477 \
    ERR4703478 \
    ERR4703479
do
    echo "========================================"
    echo "Processing $SAMPLE"
    echo "========================================"

    fastp \
        -i "$RAW/${SAMPLE}_1.fastq.gz" \
        -I "$RAW/${SAMPLE}_2.fastq.gz" \
        -o "$OUT/${SAMPLE}_1.trimmed.fastq.gz" \
        -O "$OUT/${SAMPLE}_2.trimmed.fastq.gz" \
        --detect_adapter_for_pe \
        --cut_mean_quality 20 \
        --length_required 30 \
        --thread 6 \
        --html "$REPORT/${SAMPLE}_fastp.html" \
        --json "$REPORT/${SAMPLE}_fastp.json"

    if [ $? -ne 0 ]; then
        echo "ERROR: $SAMPLE failed"
        exit 1
    fi

    echo "$SAMPLE completed successfully."
done

echo "========================================"
echo "ALL 8 SAMPLES COMPLETED"
echo "========================================"
