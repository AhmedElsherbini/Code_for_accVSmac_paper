setwd("/media/ahmed/CC69-620B6/00_Ph.D/DATA_results/0_accolens_prop_database_work/0_analysis/0_Phylogeny/z_new_collection_botswana/Itol_tool_annota_table2itol-master")
source("table2itol.R")



create_itol_files(infiles = c("full_meta_data.tsv"),
                  identifier = "names", label = c("Species"), na.strings = "X")

