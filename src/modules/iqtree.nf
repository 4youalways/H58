
process IQTREE {

    tag "$sample_id"
    container 'staphb/iqtree2:2.2.2.7'
    
    input:
    path phylo
    path constant
    
    output:
    path 'phylo.aln.*'
    
    script:
    """
    #!/bin/bash
    iqtree2 -nt AUTO -fconst \$(cat ${constant}) -s ${phylo} -m GTR+G -bb 1000  -T AUTO

    """
}
