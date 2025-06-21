**How do you download many files from the BV-BRC (PATRIC) website ?**

Download the genomes' IDs in a text file from the [website](https://www.bv-brc.org/) and the respective metadata.

Then,
```Bash
for file in *.txt; do while IFS= read -r line; do wget -qN "ftp://ftp.bvbrc.org/genomes/$line/$line.fna"; f=$(echo "$file" | sed -E "s/\.csv_list.txt*//"); mkdir -p "$f"; mv "$line.fna" "$f"; cp "$file" "$f"; done < "$file"; done
```

**How do you assemble short and hybrid long and short reads ?**

For genome assembly, we will use the friendly tool [Unicycler](https://github.com/rrwick/Unicycler)

*Shortread*

```Bash
for file in * 001.fastq.gz;do f=$(echo $file | sed -E "s/\_R1_001.fastq.gz*//"); unicycler -t 12 -o "$f" --keep 2 --short1 "$f"_R1_001.fastq.gz --R2--short2 "$f"_R2_001.fastq.gz ; done
```

*Hybrid*

```Bash

unicycler -1 AE7_2209-shA-008_S70_R1_001.fastq.gz -2 AE7_2209-shA-008_S70_R2_001.fastq.gz -l AE7_2209-shB-d1-008.fastq.gz -o output_dir
```
**Annotation**

All the genomes were annotated with Prokka and Bakta (full database) using these two commands.

Prokka

```Bash
for d in *.fna ; do f=$(echo $d | sed -E "s/\.fna*//") ; prokka  --compliant --outdir $f  --prefix $f  $d --cpus 16 ; done
```

Bakta (full database)

```Bash
for d in *.fna ; do f=$(echo $d | sed -E "s/\.fna*//") ;bakta $f.fna --verbose  --db /home/ahmed/bakta/db  --output $f --prefix $f ; done
```


**Diversity and Phylogeny**

Let's list all files and draw the heatmap with 


```Bash
ls *.fna > file.txt
```

```Bash
fastANI --rl file.txt --ql file.txt -t 64 -o fastani_output.txt
```
Then, we can use the R script above for visualization.

*What about the Maximum Likelihood tree with protein markers ?*


```Bash
phylophlan -i /beegfs/work/tu_bcoea01/my_micro/acco/faa_files_CA/faa/  -d phylophlan --nproc 28 --diversity medium  -f supermatrix_aa.cfg --databases_folder ./newfolder  --verbose  -o output 

```
Visualization was done by the [ITOL](https://itol.embl.de/) with the help of [table2ITOL](https://github.com/mgoeker/table2itol)

**Genomic characterization and pan-genome analysis**

Do not forget to mark all of your genome names with a prefix, like CAI_, CAII_,..

We can benefit from the output of Bakta using [Bakta_stats](https://github.com/AhmedElsherbini/Bakta_stats) 

For visualization, we can use an R script (number_xx).

I  will use the nice tool of [Panaroo](https://github.com/gtonkinhill/panaroo), which uses the GFF files that are out of the Prokka tool.

```Bash
panaroo -i *.gff -o results --clean-mode strict
```
Then we need to extract unique and shared genes using the presence-absence CSV file from the output of Panaroo with this simple script named [Panroo_stats](https://github.com/AhmedElsherbini/Panaroo_stats). Later visualization with other R script attached.

 For visualization, we used an R script (number_xx).

*What about AMR profiling?*

We can use the nice tool [AMRFinderPlus](https://github.com/ncbi/amr)

```Bash
for d in *.fna ; do f=$(echo $d | sed -E "s/\.fna*//") ; amrfinder -n $f.fna >> result.txt ; done
```

*What about the genome's alignment?*

Well, well, we can use the nice tool [pyGenomeViz](https://moshi4.github.io/pyGenomeViz/), just use the genbank files from long reads and play around with the nice GUI interface <code>pgv-gui</code>


**Secondary metabolites analysis and iron acquisition mechanisms**

This analysis was done using the web tool of [AntiSMASH](https://antismash.secondarymetabolites.org/#!/start).

To visualize the similarity of the BGC veruse the reference database, I downloaded the reference (which has similarity on to the core synthetic genes ) the AntiSMASH from [MIBiG](https://mibig.secondarymetabolites.org/) database, then we can use [Clinker](https://github.com/gamcil/clinker) to align the reference BGC. Then we can use [Clinker_naming](https://github.com/AhmedElsherbini/Clinker_naming) to annotate the genes as we like, which we can also use for the core genome analysis


*What about the iron acquisition systems?*

Use the fasta file from prokka, the FNA extension, and take care of the header in FASTA files, as it can interfere with analysis

```Bash
FeGenie.py -bin_dir genomes/ -bin_ext fna -out fegenie_out
```
For visualization, we can use an R script (number_xx).


**RNA seq analysis**


 For visualization, we can use an R script (number_xx).

