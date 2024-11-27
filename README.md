
```Bash
ls *.fna > file.txt
```
```Bash
fastANI --rl file.txt --ql genome_list.txt -t 64 -o fastani_output.txt
```

```Bash
phylophlan -i /beegfs/work/tu_bcoea01/my_micro/acco/faa_files_CA/faa/  -d phylophlan --nproc 28 --diversity medium  -f supermatrix_aa.cfg --databases_folder ./newfolder  --verbose  -o output 

```

```Bash
for d in *.fna ; do f=$(echo $d | sed -E "s/\.fna*//") ; genomad end-to-end --splits 8 --cleanup $d  $f ./genomad_db/  ; done
```
```Bash
for d in *.fna ; do f=$(echo $d | sed -E "s/\.fna*//") ; checkv end_to_end ${f}.fna  ${f}output -t 16 -d ./checkv-db/ ; done
```
```Bash

for dir in *; do if cd $dir; then  for filename in *quality_summary.tsv ; do mv $filename ${dir}_quality_summary.tsv ; done; cd ..; fi; done
```
```Bash

 cp **/*._quality_summary ./quality_folder
```

```Bash
 nawk 'FNR==1 && NR!=1{next;}{print}' *.tsv > merged.tsv
```

```Bash
while IFS= read -r filename; do cp "$filename" ./hq/ ; done < high_qulaity.txt
```

```Bash
panaroo -i *.gff -o results --clean-mode strict
```

```Bash
phammseqs *.faa  -p
```
```Bash
phamclust strain_genes.tsv ./phamclust
```

```Bash
for d in *.fna ; do f=$(echo $d | sed -E "s/\.fna*//") ; isescan.py --seqfile $d --output $f --nthread 28; done
```


