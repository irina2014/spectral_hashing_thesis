#!/usr/bin/env bash

# -- 0.0 Generalities/ Observations -- #
data_folder="SIFT"
data_filename="ANN_SIFT1M_128D.data"
dataset_size=1000000
compress_types=("vanilla" "balanced" "pccutrepeated" "pccutrepeatedmultiplebits" "median" "bitrepetition")
ordered_pcs="uord"

# Obs. (1) => in training, change -input name depending on ss or fr

# -- 0.1 Make folders that don't exist -- #
if [ ! -d ./Data/${data_folder}/Samples ]; then
  mkdir -p ./Data/${data_folder}/Samples;
fi
if [ ! -d ./Results/${data_folder} ]; then
  mkdir -p ./Results/${data_folder};
fi
for compress_type in "${compress_types[@]}"
do
    if [ ! -d ./Results/${data_folder}/run.${compress_type}.${ordered_pcs}/GTs ]; then
      mkdir -p ./Results/${data_folder}/run.${compress_type}.${ordered_pcs}/GTs;
    fi
    if [ ! -d ./Results/${data_folder}/run.${compress_type}.${ordered_pcs}/Logs ]; then
      mkdir -p ./Results/${data_folder}/run.${compress_type}.${ordered_pcs}/Logs;
    fi
    if [ ! -d ./Results/${data_folder}/Models ]; then
      mkdir -p ./Results/${data_folder}/Models;
    fi
    if [ ! -d ./Results/${data_folder}/Models_Logs ]; then
      mkdir -p ./Results/${data_folder}/Models_Logs;
    fi
done

sample_sizes=( 1000 5000 10000 20000 30000 40000 50000 ) # ( 1000 5000 10000 20000 30000 40000 50000 );
sample_size_testing_fraction=10
num_testing_samples=1
for sample_size in "${sample_sizes[@]}"
do
    # -- 2. Training: for each bits_to_encode_to, we create 1 model -- #
    loop_bits=( 8 16 32 64 128 256 )
    input_model=$data_folder'__ss-'$sample_size'__'

    for bits in "${loop_bits[@]}"
    do
        echo "TRAINING for bits_to_encode_to = ${bits}"
        python train.py -input "./Data/${data_folder}/Samples/${input_model}1" -model "./Results/${data_folder}/Models/${input_model}_bits-${bits}" -bits ${bits} -log_file_train "./Results/${data_folder}/Models_Logs/${input_model}_bits-${bits}.train.log" &
    done # done loop_bits loop for training
done # done sample_sizes loop
