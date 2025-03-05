#conda 24.9.2

#RepeatModeler (version = 2.0.6)
singularity pull dfam-tetools-latest.sif docker://dfam/tetools:latest #(DONT RUN AGAIN)

#activate conda env with singularity
conda activate repeatmodeler_env
singularity run ../dfam-tetools-latest.sif

BuildDatabase -name nucella_genome_no_scaffold hifi_2kb_decontaminated.fa 

#start an instance 
singularity instance start ../dfam-tetools-latest.sif run_rm

#run modeler and masker
nohup singularity exec instance://run_rm RepeatModeler -LTRStruct -database nucella_genome_no_scaffold -threads 35 &
nohup singularity exec instance://run_rm RepeatMasker -pa 35 -lib ../nucella_genome_no_scaffold-families.fa -xsmall -gff ../hifi_2kb_decontaminated.fa &


#braker3
--AUGUSTUS_CONFIG_PATH /home/meghan/config



##firefly + new hifi

#activate conda env with singularity
conda activate repeatmodeler_env
singularity run ./dfam-tetools-latest.sif

BuildDatabase -name nucella_genome_new new_hifiasm_2kb.a_ctg.filtered.fa

#start an instance 
singularity instance start ../dfam-tetools-latest.sif run_rm

#run modeler and masker
nohup singularity exec instance://run_rm RepeatModeler -LTRStruct -database nucella_genome_new -threads 35 &

