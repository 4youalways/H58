# H58

This repository contains scripts used in the analysis of the H58 isolates from Malawi

long-read assemblies
/home/azuza/styphi/trycycler/output/trycycler

isolate A58390 cluster_002 discard. It is a section of the main alignment. full alignment in cluster 001. (mauve)

# prepare assemblies for submission
sed -I .bak 's/cluster_001_consensus_polypolish/cluster_001 [organism=Salmonella enterica subsp. enterica serovar Typhi] [strain=1017142] [topology=circular] [completeness=complete]/' 1017142.fasta

sed -I .bak 's/cluster_001_consensus_polypolish/cluster_001 [organism=Salmonella enterica subsp. enterica serovar Typhi] [strain=A58390] [topology=circular] [completeness=complete]/' A58390.fasta

sed -I .bak 's/cluster_001_consensus_polypolish/cluster_001 [organism=Salmonella enterica subsp. enterica serovar Typhi] [strain=BKQU3X] [topology=circular] [completeness=complete]/' BKQU3X.fasta

sed -I .bak 's/cluster_001_consensus_polypolish/cluster_001 [organism=Salmonella enterica subsp. enterica serovar Typhi] [strain=BKQT8S] [topology=circular] [completeness=complete]/' BKQT8S.fasta

# plasmids
sed -I .bak 's/cluster_002_consensus_polypolish/cluster_002 [organism=Salmonella enterica subsp. enterica serovar Typhi] [strain=BKQT8S] [plasmid-name=IncHI1 ST2] [topology=circular] [completeness=complete]/' BKQT8S.fasta

sed -I .bak 's/cluster_002_consensus_polypolish/cluster_002 [organism=Salmonella enterica subsp. enterica serovar Typhi] [strain=BKQU3X] [plasmid-name=IncHI1 ST2] [topology=circular] [completeness=complete]/' BKQU3X.fasta
