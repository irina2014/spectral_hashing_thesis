
#!/usr/bin/env bash

# Usage example:  sh ./Bash_Scripts/evaluate-mnist.sh


# -- 0.0 Generalities/ Observations -- #
data_folder="Profi"
data_filename="profiset.tabbed.txt"
dataset_size=20000001

# Obs. (1) => in training, change -input name depending on ss or fr

# -- 0.1 Make folders that don't exist -- #
if [ ! -d ./Data/${data_folder}/Samples ]; then
  mkdir -p ./Data/${data_folder}/Samples;
fi
if [ ! -d ./Results/${data_folder} ]; then
  mkdir -p ./Results/${data_folder};
fi
if [ ! -d ./Results/${data_folder}/Logs ]; then
  mkdir -p ./Results/${data_folder}/Logs;
fi
if [ ! -d ./Results/${data_folder}/Models ]; then
  mkdir -p ./Results/${data_folder}/Models;
fi

# -- 1. Sampling data -- #
sample_sizes=( 1000 5000 10000 20000 30000 ) # ( 1000 5000 10000 20000 30000 40000 50000 ), done: 
sample_size_testing_fraction=10
num_testing_samples=1
loop_bits=( 2 4 8 16 32 64 128 256 512 )
for sample_size in "${sample_sizes[@]}"
do
    echo $sample_size
    # -- 3. Testing: for each training_model (corresponding to one category of bits_to_encode_to), we test on 5 testing sets -- #
    k_s=( 10 100 )
    mhd=10
    input_model=$data_folder'__ss-'$sample_size'__'
    for k in "${k_s[@]}"
        do
        echo "k is "$k
        if [ ! -d ./Results/${data_folder}/Logs/k_${k} ]; then
          mkdir -p ./Results/${data_folder}/Logs/k_${k};
        fi
        for bits in "${loop_bits[@]}"
        do
            echo "TESTING for model corresponding to bits_to_encode_to = ${bits}"
            if [ ! -d ./Results/${data_folder}/Logs/k_${k}/bits_${bits} ]; then
              mkdir -p ./Results/${data_folder}/Logs/k_${k}/bits_${bits};
            fi
            for ith_testing_sample in $(seq 1 $num_testing_samples);
            do
                echo "./Results/${data_folder}/Logs/${input_model}${ith_testing_sample}_bits-${bits}.test.log"
                python test.py -model "./Results/${data_folder}/Models/${input_model}_bits-${bits}" -testing "./Data/${data_folder}/Samples/${input_model}${ith_testing_sample}" -mhd ${mhd} -k ${k} -log_file_test "./Results/${data_folder}/Logs/k_${k}/bits_${bits}/${input_model}${ith_testing_sample}_bits-${bits}.test.log" -log_file_others "./Results/${data_folder}/Logs/k_${k}/bits_${bits}/${input_model}${ith_testing_sample}_bits-${bits}.others.log" -eval-type=0
            done
        done # done loop_bits loop for testing
    done # done k_S loop for testing 
done # done sample_sizes loop
