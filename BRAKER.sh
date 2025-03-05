singularity build braker3.sif docker://teambraker/braker3:latest

#pull OrthoDB file from https://bioinf.uni-greifswald.de/bioinf/partitioned_odb12/
wget https://bioinf.uni-greifswald.de/bioinf/partitioned_odb12/Metazoa.fa.gz

braker.pl --genome=genome.fa --prot_seq=orthodb.fa \
  --bam=/path/to/SRA_ID1.bam,/path/to/SRA_ID2.bam
