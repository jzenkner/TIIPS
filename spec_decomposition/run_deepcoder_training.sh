#!/bin/bash
# Copyright 2024 DeepMind Technologies Limited
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ==============================================================================

export CUDA_VISIBLE_DEVICES=${devices=0,3}
export XLA_PYTHON_CLIENT_PREALLOCATE=false
export CUDA_DEVICE_ORDER=PCI_BUS_ID

# Which generalization tasks to train on.
declare -a experiments_array=(
  "NONE"
  "LENGTH_GENERALIZATION"
  "COMPOSE_DIFFERENT_CONCEPTS"
  "SWITCH_CONCEPT_ORDER"
  "COMPOSE_NEW_OP"
  "ADD_OP_FUNCTIONALITY"
)

# Which individual model types to train.
declare -a models_array=(
  "spec_decomposer_model"
  "synthesizer_model"
  "joint_model"
  "baseline_model"
)

# Which dataset to train on.
examples=3  # Number of I/O examples in specifications.
list_length=5  # Max length of lists.
max_int=50  # Max integer.

data_dir=./tiips_data/deepcoder_data

# This training run.
run=1
base_save_dir=./tiips_results
title_without_model_type=exedec_train_deepcoder_run-${run}
save_dir=${base_save_dir}/${title_without_model_type}

# Generate comma-separated strings to pass as an argument.
experiments=$(printf ",%s" "${experiments_array[@]}")
experiments=${experiments:1}

# Each model type will be a separate XM experiment, with a separate TensorBoard.
# It wouldn't make much sense to compare models trained on different prediction
# tasks.
for model_type in "${models_array[@]}"; do

  python -m spec_decomposition.launch_train \
    --save_dir=${save_dir} \
    --dataset_type=deepcoder \
    --experiments=${experiments} \
    --dataset_dir=${data_dir} \
    --num_examples=${examples} \
    --max_program_arity=2 \
    --max_num_statements=5 \
    --deepcoder_max_list_length=${list_length} \
    --deepcoder_max_int=${max_int} \
    --num_train_steps=500000 \
    --num_eval_steps=10 \
    --model_type=${model_type} \
    --per_device_batch_size=1 \
    --lr=2e-4 \
    --embedding_dim=512 \
    --hidden_dim=1024 \
    --dropout_rate=0.1 \
    --attention_dropout_rate=0.1 \
    --num_position_buckets=32 \
    --aligned_relative_attention=1 \
    --synthesizer_corrupted_next_part_rate=0.0 \
    --seed=10 \
    --seed=20 \
    --seed=30 \
    --seed=40 \
    --seed=50 \
    --eval_freq=10000 \
    --predict_freq=50000 \
    --checkpoint_freq=50000 \
    --exp_title=${title_without_model_type}_${model_type}_predict-only \
    --predict_only=True \
    --predict_freq=1 \


    # Add these for the prediction-only job.
    # --exp_title=${title_without_model_type}_${model_type}_predict-only \
    # --predict_only=True \
    # --predict_freq=1 \

    # Use these for quick iteration.
    # --log_freq=500 \
    # --eval_freq=1000 \
    # --predict_freq=1000 \

done
