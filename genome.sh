#remove adapter (version = )
porechop -i input_reads.fastq.gz -o output_reads.f

#filter reads (version = )
NanoFilt -l 1000 nucella1_chop.fastq > long_reads.fastq 

#assemble (version = )
flye --nano-hq all3_longreads.fastq --out-dir all3_genome --threads 50 --genome-size 2gb

#map reads to assembly (version = )
nohup minimap2 -t 60 -xmap-ont  -I 2286585804 \
-c /home/meghan/nucella_genome/2kb_noPHRED/all5_genome/assembly.fasta /home/meghan/nucella_genome/all5_flowcell/all5_all_reads_q3.fastq \
-o /home/meghan/nucella_genome/purge_dups/2kb_flye.paf &

#purge dups (version = )
nohup purge_dups -2 -T cutoffs -c PB.base.cov 2kb_flye.split.self.paf  > dups.bed 2> purge_dups.log &
get_seqs -e dups.bed /home/meghan/nucella_genome/2kb_noPHRED/all5_genome/assembly.fasta

#polish with Flye (version = )
nohup flye --polish-target /home/meghan/nucella_genome/purge_dups/2kb_flye_purgeDup.fasta --nano-hq \
/home/meghan/nucella_genome/all5_flowcell/all5_all_reads_q3.fastq --iterations 3 --threads 20 -o 2kb_flye_purgeDup_3polish &
