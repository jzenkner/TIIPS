# TIIPS: Transductively Informed Inductive Program Synthesis

This repository contains code, datasets, and references to pretrained models for our paper:
*TIIPS: Transductively Informed Inductive Program Synthesis*


## 🧠 Overview

**TIIPS** builds on [ExeDec](https://github.com/google-deepmind/exedec) to improve generalization in neural program synthesis. While ExeDec applies **transductive guidance rigidly at every step**, TIIPS introduces **sparse and iterative guidance** by combining:

- An **inductive program generator** that constructs a program step by step
- A **transductive model** that predicts intermediate outputs only when inductive synthesis fails

This adaptive framework balances inductive reasoning with transductive guidance, improving synthesis across both **list** and **string** domains.


## 🔍 Key Contributions

- A **hybrid synthesis framework** integrating inductive and transductive reasoning
- Empirical improvements over ExeDec across diverse **compositional generalization** benchmarks
- Selective invocation of transductive guidance, reducing overhead without sacrificing performance


## ⚙️ Installation

Install required dependencies:

```bash
pip install numpy tensorflow absl-py
pip install flax==0.5.3
pip install jax==0.3.25 jaxlib==0.3.25 -f https://storage.googleapis.com/jax-releases/jax_releases.html
pip install tqdm
```

## 📁 Datasets

We evaluate **TIIPS** using the compositional generalization splits from **ExeDec** in two domains:

- **DeepCoder**: list manipulation  
- **RobustFill**: string manipulation

Each domain includes 5 generalization types:

- `NONE` (test on training distribution)
- `LENGTH_GENERALIZATION`  
- `COMPOSE_DIFFERENT_CONCEPTS`  
- `SWITCH_CONCEPT_ORDER`  
- `COMPOSE_NEW_OP`  
- `ADD_OP_FUNCTIONALITY`  

## 📂 Data Availability

Test data and model checkpoints are available via GCS. Details can be found at the [ExeDec repo](https://github.com/google-deepmind/exedec).

## 🏋️ Training
To generate training data, run:
```bash
bash tasks/deepcoder/dataset/run_data_generation.sh
bash tasks/robustfill/dataset/run_data_generation.sh
```

To train TIIPS models, run:

```bash
bash tiips/run_deepcoder_training.sh
bash tiips/run_robustfill_training.sh
```

These scripts: Load data and pretrain the transductive and inductive model.
You may need to adjust them for your environment (e.g., TPU, SLURM, Docker).


## 🧪 Evaluation
To evaluate pretrained checkpoints:

```bash
Copy
Edit
bash tiips/run_deepcoder_end_to_end_predict.sh
bash tiips/run_robustfill_end_to_end_predict.sh
```

These use end_to_end_predict.py, which: Synthesizes programs using the inductive model, invokes transductive model if synthesis fails, and iteratively builds a full solution.

