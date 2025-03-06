#https://github.com/Gaius-Augustus/BRAKER/issues/609

singularity build braker3.sif docker://teambraker/braker3:latest

#pull OrthoDB file from https://bioinf.uni-greifswald.de/bioinf/partitioned_odb12/
wget https://bioinf.uni-greifswald.de/bioinf/partitioned_odb12/Metazoa.fa.gz

#activate conda env with singularity
conda activate repeatmodeler_env


#braker3
singularity run ./braker3.sif


nohup singularity exec -B /home/meghan/nucella_genome/annotate/no_scaffold/v1_braker /home/meghan/braker3.sif braker.pl \
--genome=/home/meghan/nucella_genome/annotate/no_scaffold/hifi_2kb_decontaminated.fa.masked \
--species=v1_nucella  --softmasking --threads=35 \
--prot_seq=/home/meghan/nucella_genome/database/Metazoa.fa \
--bam=/home/meghan/nucella_genome/annotate/no_scaffold/all_mapped_rna.bam \
--AUGUSTUS_CONFIG_PATH=/home/meghan/config &

#entap on firefly 

singularity run ../entap.sif
EnTAP --config --run-ini entap_run.params --entap-ini entap_config.ini -t 5




