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


declare -a experiments_array=(
    "NONE"
    "LENGTH_GENERALIZATION"
    "COMPOSE_DIFFERENT_CONCEPTS"
    "SWITCH_CONCEPT_ORDER"
    "COMPOSE_NEW_OP"
    "ADD_OP_FUNCTIONALITY"
)
declare -a splits_array=(
  "train"
  "valid"
  "test"
)

# Change these options as desired.
seed=0  # Base seed that affects each worker differently.
num_processes=16
num_examples=4
max_input_length=20

dataset_name=robustfill_data
base_save_dir=./tiips_data

# Whether to generate a full dataset or just a small one for testing purposes.
GENERATE_FULL_DATA=true
if ${GENERATE_FULL_DATA}; then
  echo 'Generating full dataset'
  # We train for 500K steps on 8 devices with a per-device batch size of 16, or
  # 64M examples total. These settings will generate that many programs. (Also
  # note that the decomposed data will have multiple data elements per program,
  # but we still need this many programs for training a no-decomposition
  # baseline, if we control for the number of training steps.)
  num_train_shards=128
  num_train_programs_per_shard=500000
  # 10K test examples, although the experiments only use the first 1000 of them.
  num_test_programs=10000
else
  echo 'Generating small dataset'
  num_train_shards=2
  num_train_programs_per_shard=1000
  num_test_programs=200
fi

# Generate comma-separated strings to pass as an argument.
experiments=$(printf ",%s" "${experiments_array[@]}")
experiments=${experiments:1}
splits=$(printf ",%s" "${splits_array[@]}")
splits=${splits:1}

python -m tasks.robust_fill.dataset.run_data_generation \
  --seed=${seed} \
  --save_dir=${base_save_dir}/${dataset_name} \
  --num_processes=${num_processes} \
  --experiments=${experiments} \
  --splits=${splits} \
  --num_train_shards=${num_train_shards} \
  --num_train_programs_per_shard=${num_train_programs_per_shard} \
  --num_test_programs=${num_test_programs} \
  --num_examples=${num_examples} \
  --max_input_length=${max_input_length} \
