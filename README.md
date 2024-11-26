
```Bash
ls *.fna > file.txt

fastANI --rl file.txt --ql genome_list.txt -t 64 -o fastani_output.txt
```

```Bash
phylophlan -i /beegfs/work/tu_bcoea01/my_micro/acco/faa_files_CA/faa/  -d phylophlan --nproc 28 --diversity medium  -f supermatrix_aa.cfg --databases_folder ./newfolder  --verbose  -o output 

```

```Bash
for d in *.fna ; do f=$(echo $d | sed -E "s/\.fna*//") ; genomad end-to-end --splits 8 --cleanup $d  $f ./genomad_db/  ; done
```



```Bash
for d in *.fna ; do f=$(echo $d | sed -E "s/\.fna*//") ; isescan.py --seqfile $d --output $f --nthread 28; done
```

```Bash
panaroo -i *.gff -o results --clean-mode strict
```

```Bash

conda activate phammseqs-envs
```
```Bash
phammseqs *.faa  -p
```
```Bash
phamclust strain_genes.tsv ./phamclust
```
