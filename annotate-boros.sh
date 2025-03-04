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
conda activate repeatmodeler_env

singularity instance start ../dfam-tetools-latest.sif run_rm


nohup singularity exec instance://run_rm RepeatModeler -LTRStruct -database nucella_genome_no_scaffold -threads 35 &


nohup singularity exec instance://run_rm RepeatMasker -pa 35 -lib ../nucella_genome_no_scaffold-families.fa -xsmall -gff ../hifi_2kb_decontaminated.fa &


#braker3
--AUGUSTUS_CONFIG_PATH /home/meghan/config



##firefly + new hifi

BuildDatabase -name nucella_genome_new new_hifiasm_2kb.a_ctg.fa

nohup singularity exec instance://run_rm RepeatModeler -LTRStruct -database nucella_genome_new -threads 35 &

