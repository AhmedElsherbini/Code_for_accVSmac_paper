#In The name of Allah the most merciful 
#some genomes were Downloaded from PATRIC
#patric database #PS:this website is closed by 14/12/2022.and replaced by BV-BVRC
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

###########################################################################################################################################
#0
#for phylogentic analysis
#Make sure to have an outgroup species #in this anaylsis was 
#This analysis was done on the HPC
#Make sure that folder contains your islates only in faa file no other extra files even if in other extension
phylophlan -i /beegfs/work/tu_bcoea01/my_micro/acco/faa_files_CA  -d phylophlan  --nproc 32 --diversity low  -f supermatrix_aa.cfg --databases_folder ./newfolder  --verbose   -o acco_mac_T_12_6
#further annoation was done on ITOL (https://itol.embl.de/)
##############################################################################################################1
#1
#for the analysis of FastAni
ls -1 -d *.fna > genome_list.txt
fastANI --rl genome_list.txt --ql genome_list.txt -t 32 -o fastani_output.txt
#Then the output you can use the R script for making graph
#############################################################################################################
#2
#based on ref: https://github.com/KLemonLab/DpiMGE_Manuscript/blob/master/SupplementalMethods_Anvio.md
#https://anvio.org/help/7/programs/anvi-setup-ncbi-cogs/
#################################################################################################
#mkdir -p "analysis_Anvio7/Reformat_Dpig"
#path_f="./1_input_fna/"
#path_o="./2_format_fna/"
#############################################################################################################
#for file in $path_f/*.f*; do
  #  FILENAME=`basename ${file%.*}`
 #   anvi-script-reformat-fasta -o $path_o/$FILENAME.fa --min-len 0 --simplify-names $file --seq-type NT; 
#done


#############################################################################################################
#cd ./2_format_fna
#############################################################################################################
#for d in *.fa ; do f=$(echo $d | sed -E "s/\.fa*//") ; prokka --outdir $f  --prefix $f  $d ; done
#############################################################################################################
#mkdir -p "analysis_Anvio7/Parsed_prokka_Dpig"
#path_f="/home/ahmed/analysis_Anvio7/2_format_fna/gff/"
#path_o="/home/ahmed/analysis_Anvio7/3_gff_parsed"

#for file in $path_f/*.gff; do
  #  FILENAME=`basename ${file%.*}`
 #   python gff_parser.py --gene-calls $path_o/calls_$FILENAME.txt --annotation $path_o/annot_$FILENAME.txt $file;
#done

#############################################################################################################
#mkdir -p "analysis_Anvio7/Contigs_db_prokka_Dpig"
#############################################################################################################
#path_f="/home/ahmed/analysis_Anvio7/2_format_fna"
#path_o="/home/ahmed/analysis_Anvio7/4_contigs_DB"
#path_e="/home/ahmed/analysis_Anvio7/3_gff_parsed"

#for file in $path_f/*.fa; do
 #   FILENAME=`basename ${file%.*}`
  #  anvi-gen-contigs-database -f $file \
   #                           -o $path_o/$FILENAME.db \
    #                          --external-gene-calls $path_e/calls_$FILENAME.txt \
     #                         --ignore-internal-stop-codons \
      #                        -n $FILENAME;
#done

#############################################################################################################
#path_f="/home/ahmed/analysis_Anvio7/4_contigs_DB"
#path_e="/home/ahmed/analysis_Anvio7/3_gff_parsed"

#for file in $path_f/*.db; do
   # FILENAME=`basename ${file%.*}`
  #  anvi-import-functions -c $file \
 #                         -i $path_e/annot_$FILENAME.txt
      
#done

  

#anvi-setup-ncbi-cogs --just-do-it
#############################################################################################################
#this needs the cluster
path_f="/home/ahmed/analysis_Anvio7/4_contigs_DB"

for file in $path_f/*.db; do
    anvi-run-ncbi-cogs -T 4 --sensitive -c $file;
done

#############################################################################################################
#3
#Roary analysis

roary -r -f accolens  -e --mafft  -p 32 CA*

roary -r -f mac  -e --mafft  -p 32 CM*

roary -r -f all  -e --mafft -p 32  *.gff

query_pan_genome -a difference --input_set_one \

CA_ATCC_49725.gff,\
CA_ATCC_49726.gff,\
CA_BBMGS-S02-097.gff,\
CA_MAM_C779.gff,\
CA_MAM_C781.gff,\
CA_MAM_C787.gff,\
CA_SDB_CI5886.gff,\
CA_SDB_Cl5456.gff,\
CA_SDB_Cl6012.gff,\
CA_SDB_Cl5570.gff,\
CA_SH_157.gff,\
CA_SH_181.gff,\
CA_SH_184.gff,\
CA_SH_192.gff,\
CA_SH_219.gff,\
CA_SH_23.gff,\
CA_SH_247.gff,\
CA_SH_262.gff,\
CA_KPL_1996.gff,\
CA_KPL_1818.gff,\
CA_KPL_1824.gff,\
CA_KPL_1855.gff,\
CA_SH_281.gff,\
CA_SH_41.gff,\
CA_SH_79.gff,\
CA_SH_98.gff,\
CA_strain_NCTC934.gff \

--input_set_two \

CM_strain_06T638.gff,\
CM_strain_12T220.gff,\
CM_strain_12T66.gff,\
CM_strain_14T168.gff,\
CM_strain_14T424.gff,\
CM_strain_14T514.gff,\
CM_strain_14T631.gff,\
CM_strain_150801.gff,\
CM_strain_151011.gff,\
CM_strain_160430.gff,\
CM_strain_160603.gff,\
CM_strain_160806.gff,\
CM_strain_160811.gff,\
CM_strain_160812.gff,\
CM_strain_161211.gff,\
CM_strain_170718.gff,\
CM_strain_171015.gff,\
CM_strain_171203.gff,\
CM_strain_180126.gff,\
CM_strain_180208.gff,\
CM_strain_180216.gff,\
CM_strain_9T245.gff,\
CM_strain_CCUG_32361.gff,\
CM_strain_NML_080212.gff,\
CM_strain_NML_120205.gff

