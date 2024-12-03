
library(devtools)

# set colors
date_col <- c("1996"="#000000", "1997" = "#0A0A0A", "1998" =  "#151515", "1999" = "#1F1F1F", "2000" = "#2A2A2A", "2001" = "#353535","2002" =  "#3F3F3F", "2003" = "#4A4A4A", "2004" = "#555555", "2005" = "#5F5F5F", "2006" = "#6A6A6A", "2007" = "#747474", "2008" = "#7F7F7F", "2009" = "#8A8A8A", "2010" = "#949494", "2011" = "#9F9F9F", "2012" = "#AAAAAA", "2013" = "#B4B4B4", "2014" = "#BFBFBF", "2015" = "#C9C9C9", "2016" = "#D4D4D4", "2017" = "#DFDFDF", "2018" = "#E9E9E9", "2019" = "#F4F4F4",  "2020" = "#FFFFFF")
usethis::use_data(date_col, overwrite = TRUE)

genotype_col <- c("4.1.1" = "blue", "4.3.1.1" = "green", "4.3.1.1.EA1" = "Yellow", "4.3.1.2" = "Pink")

group_col <- c("This study" = "#CC6677", "Other" = "#f6e8c3")

region_col <- c("Other"  = "#f6e8c3", "Malawi" = "#440154")

amr_gene_col <- c("1" = "#01665e" , "0" = "#f6e8c3")

# dna segment colors
is_elements <- c("IS1X2", "ISVsa5")
gene_seg_colors <- c("IS1X2" = "#01665e", "TnAs2" = "#01665e", "tetC" = "#01665e", "IS4321R" = "#01665e", "tetR" = "#01665e", "IS4321L" = "#01665e", "ISVsa5" = "#01665e", "ISBcen27" = "#01665e", "IS4321R" = "#01665e", "IS26" = "#01665e", "ISStma11" = "#01665e", "IS5075" = "#01665e", "IS1R" = "#01665e", "ISVsa5" ="#01665e", "TnAs3" = "#01665e", "ISVsa5" = "#01665e",  "IS1R" = "#01665e",
                     "-" = "#f6e8c3", "merR" ="#440154",  "merT_1" = "#440154", "merP_1" ="#440154", "merC_1" ="#440154", "merA_1" = "#440154", "dfrA14" = "#440154", "IS26" = "#440154","blaTEM-1" = "#440154", "sul2"= "#440154", "aph(3'')-Ib" = "#440154",  "aph(6)-Id" = "#440154", "merA_2" = "#440154", "merC_2" = "#440154", "merP_2" = "#440154", "merP_2" = "#440154", "merT_2" = "#440154", "tet(B)" ="#440154",
                     "repE" = "#f6e8c3", "xerC" = "#f6e8c3", "hin" = "#f6e8c3", "hns" = "#f6e8c3", "smc" = "#f6e8c3", "dcm" = "#f6e8c3", "tnpR" = "#f6e8c3", "repA" = "#f6e8c3", "yqjZ" = "#f6e8c3", "umuD" = "#f6e8c3", "umuC"= "#f6e8c3")

gene_seg_colors

