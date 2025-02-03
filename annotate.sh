#conda 24.9.2


# trim and filter raw reads (fastp v0.23.4)
fastp -i combined_nucella_rna.fastq -o fastp_combined_nucella_rna.fastq -t 40


##map reads to genome
#make genome dir for STAR (version = )
STAR --runThreadN 30 --runMode genomeGenerate --genomeDir /home/meghan/nucella_genome/annotate/index --genomeFastaFiles /home/meghan/nucella_genome/decontaminate/len1kb_20x_metazoa_polish3.fasta

#map rna 
STAR --genomeDir /home/meghan/nucella_genome/annotate/index \
      --readFilesIn /home/meghan/nucella_genome/annotate/rna/fastp_combined_nucella_rna.fastq \
      --outSAMtype BAM SortedByCoordinate \
      --outFileNamePrefix mapped_fastp_rna

#RepeatModeler (version = 2.0.6)
conda activate repeatmodeler_env
BuildDatabase -name nucella_genome len1kb_20x_metazoa_polish3.fasta 
nohup bash -c "RepeatModeler -LTRStruct -database nucella_genome -threads 38" >  Rmodler.log 2>&1 &

RepeatMasker -pa 10 -lib families.fa -xsmall -gff len1kb_20x_metazoa_polish3.fasta


#braker3
--AUGUSTUS_CONFIG_PATH /home/meghan/config
