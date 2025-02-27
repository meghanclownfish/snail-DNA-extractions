#conda 24.9.2


# trim and filter raw reads (fastp v0.23.4)
fastp -i combined_nucella_rna.fastq -o fastp_combined_nucella_rna.fastq -t 40

#RepeatModeler (version = 2.0.6)
singularity pull dfam-tetools-latest.sif docker://dfam/tetools:latest #(DONT RUN AGAIN)

conda activate repeatmodeler_env
singularity run ../dfam-tetools-latest.sif

BuildDatabase -name nucella_genome_no_scaffold hifi_2kb_decontaminated.fa 
nohup bash -c "RepeatModeler -LTRStruct -database nucella_genome_no_scaffold -threads 32" >  Rmodler.log 2>&1 &

#or 

#start an instance 

singularity instance start ../dfam-tetools-latest.sif run_rm
singularity run instance://run_rm nohup RepeatModeler -LTRStruct -database nucella_genome_no_scaffold -threads 32 &


RepeatMasker -pa 10 -lib families.fa -xsmall -gff len1kb_20x_metazoa_polish3.fasta


#braker3
--AUGUSTUS_CONFIG_PATH /home/meghan/config
