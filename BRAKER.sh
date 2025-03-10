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

#initial busco: 72.7%, running again with eukaryota + mollusca instead of metazoa 

nohup singularity exec -B /home/meghan/nucella_genome/annotate/no_scaffold/brakerR2 /home/meghan/braker3.sif braker.pl \
--genome=/home/meghan/nucella_genome/annotate/no_scaffold/hifi_2kb_decontaminated.fa.masked \
--species=r2_nucella  --softmasking --threads=35 \
--prot_seq=/home/meghan/nucella_genome/database/eukaryota_and_molluscan_protien.fasta \
--bam=/home/meghan/nucella_genome/annotate/no_scaffold/all_mapped_rna.bam \
--AUGUSTUS_CONFIG_PATH=/home/meghan/config &

# not much better; tsebra is doing something weird. go in and run manually and reinforce agusstus to fix 

#enforce aug
singularity exec /home/meghan/braker3.sif tsebra.py \
-g /home/meghan/nucella_genome/annotate/no_scaffold/brakerR3/braker/GeneMark-ETP/genemark.gtf \
-k /home/meghan/nucella_genome/annotate/no_scaffold/brakerR3/braker/Augustus/augustus.hints.gtf \
-e /home/meghan/nucella_genome/annotate/no_scaffold/brakerR3/braker/hintsfile.gff \
-c no_enforcement.cfg -o aug_enforcement.gtf 

# keep longest iso and extract protein seq

agat_sp_keep_longest_isoform.pl -f aug_enforcement.gtf -o iso_filt_aug_enforcement.gtf
# 9597 L2 isoforms with CDS removed (shortest CDS)

# extract prot seq 
agat_sp_extract_sequences.pl -g iso_filt_aug_enforcement.gtf \
-f /home/meghan/nucella_genome/annotate/no_scaffold/hifi_2kb_decontaminated.fa.masked \
-o iso_filt_aug_enforcement.faa -p

#entap with uniprot_sprot an refseq_invertebrarte

singularity run ../entap.sif
EnTAP --config --run-ini entap_run.params --entap-ini entap_config.ini -t 5

#update all paths with given info before moving on, for eggNog SQL database, include path but not file (EnTap will not understand if you give file) 

EnTAP --run -i /home/meghan/nucella_genome/annotate/no_scaffold/brakerR3/braker/alternate_tsebra/output_prot/iso_filt_aug_enforcement.faa -t 35




