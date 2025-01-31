# using rna from SRA-SRX357400

# trim and filter raw reads (version = 0.23.4)
fastp -i combined_nucella_rna.fastq -o fastp_combined_nucella_rna.fastq -t 40


##map reads to genome
#make genome dir for STAR (version = )
STAR --runThreadN 30 --runMode genomeGenerate --genomeDir /home/meghan/nucella_genome/annotate/index --genomeFastaFiles /home/meghan/nucella_genome/decontaminate/len1kb_20x_metazoa_polish3.fasta

#map rna 

STAR --genomeDir /home/meghan/nucella_genome/annotate/index \
      --readFilesIn /home/meghan/nucella_genome/annotate/rna/fastp_combined_nucella_rna.fastq \
      --outSAMtype BAM SortedByCoordinate \
      --outFileNamePrefix mapped_fastp_rna

