**How do you download many files from the BV-BRC (PATRIC) website ?**

Download the genomes' IDs in a text file from the [website](https://www.bv-brc.org/) and the respective metadata.

Then,
```Bash
for file in *.txt; do while IFS= read -r line; do wget -qN "ftp://ftp.bvbrc.org/genomes/$line/$line.fna"; f=$(echo "$file" | sed -E "s/\.csv_list.txt*//"); mkdir -p "$f"; mv "$line.fna" "$f"; cp "$file" "$f"; done < "$file"; done
```

**Annotation**

all the genomes were annotated with prokka and bakta (full database) using these two commands.


```Bash
for d in *.fna ; do f=$(echo $d | sed -E "s/\.fna*//") ; prokka  --compliant --outdir $f  --prefix $f  $d --cpus 16 ; done
```
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

```Bash
phylophlan -i /beegfs/work/tu_bcoea01/my_micro/acco/faa_files_CA/faa/  -d phylophlan --nproc 28 --diversity medium  -f supermatrix_aa.cfg --databases_folder ./newfolder  --verbose  -o output 

```
Visualization was done by the ITOL with the help of [table2ITOL](https://github.com/mgoeker/table2itol)

**Genomic characterization**

We can benefit from the output of Bakta using [Bakta_stats](https://github.com/AhmedElsherbini/Bakta_stats) 

```Bash
 python bakta_stats.py -i ./txt 
```
Then for visualization is done with R using this script

**Core genome analysis**

```Bash
panaroo -i *.gff -o results --clean-mode strict
```
