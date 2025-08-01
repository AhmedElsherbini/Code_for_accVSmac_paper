

files=(
    "RNAseqData_Feb25/NGSQBBBD024A2/QBBBD024A2_20250211144301__Ca3plus_S173_R1_001.fastq.gz"
"RNAseqData_Feb25/NGSQBBBD021AC/QBBBD021AC_20250211144301__Ca3_S170_R1_001.fastq.gz"
"RNAseqData_Feb25/NGSQBBBD019A1/QBBBD019A1_20250211144301__Ca1_S167_R1_001.fastq.gz"
"RNAseqData_Feb25/NGSQBBBD022AK/QBBBD022AK_20250211144301__Ca1plus_S171_R1_001.fastq.gz"
"RNAseqData_Feb25/NGSQBBBD023AS/QBBBD023AS_20250211144301__Ca2plus_S172_R1_001.fastq.gz"
"RNAseqData_Feb25/NGSQBBBD020A4/QBBBD020A4_20250211144301__Ca2_S168_R1_001.fastq.gz"
)

for file in "${files[@]}"; do
    identifier=$(basename "$file" | grep -oP 'Ca[^_]*_')
    NXF_VER=21.10.6 nextflow run rnaSeq-pipeline/main.nf \
        --reads "$file" \
        --reference ncbi_dataset/data/GCF_000478135.1/GCF_000478135.1_Cory_sp_KPL1818_V1_genomic.fna.gz \
        --gff ncbi_dataset/data/GCF_000478135.1/genomic.gff.gz \
        --g gene_id\
        --t transcript\
        --M \
        --fraction \
        --O \
        --fracOverlap 0.7 \
        --minOverlap 10 \
        --pubDir "Overlapping_Multimap_0.7_10_$identifier" \
        -profile conda -resume
done