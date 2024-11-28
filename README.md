**How do you download many files from the BV-BRC (PATRIC) website ?**

Download the genomes ids in text file from the website  https://www.bv-brc.org/ and the respective metadata.

Then,
```Bash
for file in *.txt; do while IFS= read -r line; do wget -qN "ftp://ftp.bvbrc.org/genomes/$line/$line.fna"; f=$(echo "$file" | sed -E "s/\.csv_list.txt*//"); mkdir -p "$f"; mv "$line.fna" "$f"; cp "$file" "$f"; done < "$file"; done
```

**Annotation**

all the genomes were annotated with prokka and bakta (full database) using these two commands.


```Bash
for d in *.fna ; do f=$(echo $d | sed -E "s/\.fna*//") ; prokka   --compliant --outdir $f  --prefix $f  $d --cpus 16 ; done
```
```Bash
for d in *.fna ; do f=$(echo $d | sed -E "s/\.fna*//") ;bakta $f.fna --verbose  --db /home/ahmed/bakta/db  --output $f --prefix $f ; done
```


**Diversity and Phylogeny**

let's list all files and draw the heatmap with 


```Bash
ls *.fna > file.txt
```

```Bash
fastANI --rl file.txt --ql file.txt -t 64 -o fastani_output.txt
```
Then we can use the R-script above for visualization.

```Bash
phylophlan -i /beegfs/work/tu_bcoea01/my_micro/acco/faa_files_CA/faa/  -d phylophlan --nproc 28 --diversity medium  -f supermatrix_aa.cfg --databases_folder ./newfolder  --verbose  -o output 

```
visualization was done by the ITOL with the help of ITOL(https://github.com/mgoeker/table2itol)

**Genomic characterization**

we can benefit from the output of bakta using bakta_stats (https://github.com/AhmedElsherbini/Bakta_stats) 

```Bash
 python bakta_stats.py -i ./txt 
```
then visualization is done with R using this script

for insertion elements we use isescan

```Bash
for d in *.fna ; do f=$(echo $d | sed -E "s/\.fna*//") ; isescan.py --seqfile $d --output $f --nthread 28; done
```
Then using a collection of the data using (https://github.com/AhmedElsherbini/ISEScan_stats) and visualization using 

**Phage population analysis**

```Bash
for d in *.fna ; do f=$(echo $d | sed -E "s/\.fna*//") ; genomad end-to-end --splits 8 --cleanup $d  $f ./genomad_db/  ; done
```
Then all provirus genomes shall be collected in one folder using 

```Bash
cp **/*virus.fna ./genomes
```

delete empty files

```Bash
find . -size 0 -delete
```
Then we can use (https://github.com/AhmedElsherbini/Convert_and_print_multifasta) to generate one file per prophage.

To focus only on prophages with high quality, we can use checkv

```Bash
for d in *.fna ; do f=$(echo $d | sed -E "s/\.fna*//") ; checkv end_to_end ${f}.fna  ${f}output -t 16 -d ./checkv-db/ ; done
```
to collect the quality files we need to name them with the folder name
```Bash

for dir in *; do if cd $dir; then  for filename in *quality_summary.tsv ; do mv $filename ${dir}_quality_summary.tsv ; done; cd ..; fi; done
```
let's collect them,

```Bash
 cp **/*._quality_summary ./quality_folder
```
We need to add the name of the file in the first  colum

```Bash
for file in *.tsv; do awk -v fname="$(basename "$file" .tsv)" 'NR==1 {print $0; next} {print fname "\t" $0}' "$file" > "${file%.tsv}_modified.tsv" ; done
```

merge all of them in one tsv file

```Bash
nawk 'FNR==1 && NR!=1{next;}{print}' *.tsv > merged.tsv
```

then you can open the TSV file in LibreOffice and sort out the high-quality prophages in  <code>high_qulaity.txt</code>

then let's make a folder named hq and move the genomes for
```Bash
while IFS= read -r filename; do cp "$filename" ./hq/ ; done < high_qulaity.txt
```
then you can annotate these genomes with prokka or pharokka, the proteome files then are needed for clustering using (https://github.com/chg60/phamclust)

```Bash
phammseqs *.faa  -p
```
```Bash
phamclust strain_genes.tsv ./phamclust
```
let's investigate the COG20 

```Bash
for d in *.faa ; do f=$(echo $d | sed -E "s/\.faa*//") ; mkdir $f ; COGclassifier -i $f.faa -o ./$f ; done
```

name all classfier_results files  by the name of the genome

```Bash
for dir in *; do if cd $dir; then  for filename in *classifier_result.tsv ; do mv $filename ${dir}_classifier_result.tsv ; done; cd ..; fi; done
```


**Core genome analysis**

```Bash
panaroo -i *.gff -o results --clean-mode strict
```
