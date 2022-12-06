#In The name of Allah the most merciful 
#some genomes were Downloaded from PATRIC
patric database #PS:this website is closed by 14/12/2022.and replaced by BV-BVRC
https://legacy.patricbrc.org/ 
#as a fast and quick qc, the identdy with CGE website 
http://www.genomicepidemiology.org/

#other genomes were assembled on the high performance cluster computer (HPC) The bwForCluster BinAC 
#https://wiki.bwhpc.de/e/BinAC
conda activate shovill

for file in * 001.fastq.gz;do f=$(echo $file | sed -E "s/\_R1_001.fastq.gz*//"); shovill  --cpus 28 --ram 128 --trim -outdir "$f" --R1 "$f"_R1_001.fastq.gz --R2 "$f"_R2_001.fastq.gz ; done

#in case of genomes sequced by hybrid assembly
#https://nf-co.re/bacass/usage #by Dr.Jeffery Power
nextflow run nf-core/bacass --input samplesheet.csv -profile docker --skip_kraken2

#all genomes were annonated using prokka and bakta
for d in *.fna ; do
     f=$(echo $d | sed -E "s/\.fna*//")
     prokka --outdir $f  --complaint --prefix $f  $d
     
 done


#for bakta

conda activate bakta

bakta_db download --output /beegfs/work/tu_bcoea01/bakta

 for d in *.fasta ; do
     f=$(echo $d | sed -E "s/\.fasta*//")
     bakta --db /beegfs/work/tu_bcoea01/bakta/db --output $f --prefix $f --compliant $d

 done

##############################
#for phylogentic analysis
#Make sure to have an outgroup species #in this anaylsis was 
#This analysis was done on the HPC
phylophlan -i /beegfs/work/tu_bcoea01/my_micro/acco/faa_files_CA  -d phylophlan  --nproc 32 --diversity low  -f supermatrix_aa.cfg --databases_folder ./newfolder  --verbose   -o acco_mac_T_12_6
#further annoation was done on ITOL (https://itol.embl.de/)
##############################
#for the analysis of FastAni
ls -1 -d *.fna > genome_list.txt
fastANI --rl genome_list.txt --ql genome_list.txt -t 32 -o fastani_output.txt
#Then the output you can use the R script for making graph


