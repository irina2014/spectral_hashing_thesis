
#!/usr/bin/env bash


# -- 0.0 Generalities/ Observations -- #
data_folder="Random"


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
if [ ! -d ./Results/${data_folder}/GTs ]; then
  mkdir -p ./Results/${data_folder}/GTs;
fi

# -- 1. Sampling data -- #
sample_sizes=( 1000 5000 10000 20000 30000 40000 50000 ) # ( 1000 5000 10000 20000 30000 40000 50000 100000 ), done:
sample_size_testing_fraction=10
num_testing_samples=1
loop_bits=( 8 16 32 64 128 256 ) # ( 8 16 32 64 128 256 )
eval_types=( 1 ) # ( 0 1 2 )
for sample_size in "${sample_sizes[@]}"
do
    sample_size_testing=$(($sample_size/$sample_size_testing_fraction))
    echo $sample_size
    echo $sample_size_testing
    # -- 3. Testing: for each training_model (corresponding to one category of bits_to_encode_to), we test on 5 testing sets -- #
    k_s=( 100 ) #  ( 10 50 100 )
    mhd=30
    input_model=$data_folder'__ss-'$sample_size'__'
    testing_file=$data_folder'__ss-'$sample_size_testing'__'
    for k in "${k_s[@]}"
        do
        echo "k = "$k
        if [ ! -d ./Results/${data_folder}/Logs/k_${k} ]; then
          mkdir -p ./Results/${data_folder}/Logs/k_${k};
        fi
        for bits in "${loop_bits[@]}"
        do
            echo "TESTING for model corresponding to bits_to_encode_to = ${bits}"
            if [ ! -d ./Results/${data_folder}/Logs/k_${k} ]; then
              mkdir -p ./Results/${data_folder}/Logs/k_${k};
            fi
            for ith_testing_sample in $(seq 1 $num_testing_samples);
            do
                for eval_type in "${eval_types[@]}"
                do
#                    echo "./Results/${data_folder}/Logs/${input_model}${ith_testing_sample}_bits-${bits}.test.log"
                    echo "Evaluation is done with file => ./Data/${data_folder}/Samples/${testing_file}${ith_testing_sample}"
                    echo "eval_type = "${eval_type}

                    python test.py -model "./Results/${data_folder}/Models/${input_model}_bits-${bits}" -testing "./Data/${data_folder}/Samples/${testing_file}${ith_testing_sample}" -mhd ${mhd} -k ${k} -log_file_test "./Results/${data_folder}/Logs/k_${k}/${input_model}${ith_testing_sample}_bits-${bits}.test.log" -log_file_others "./Results/${data_folder}/Logs/k_${k}/${input_model}${ith_testing_sample}_bits-${bits}.others.log" -eval_type=${eval_type} &
                done
            done
        done # done loop_bits loop for testing
    done # done k_S loop for testing 
done # done sample_sizes loop
