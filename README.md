# Artificial-Neural-Network-workbook

A collection of **Artificial Neural Network learning notebooks** in PyTorch. Each topic lives in its own
folder and is self-contained, so you can run any notebook:

- **Locally** with [uv](https://docs.astral.sh/uv/) — one shared environment, no setup scripts.
- **In the cloud** with **Open in Colab** — datasets download automatically, nothing to install.

## Notebooks

| Folder | Notebook | Dataset | Task | Framework | Colab |
|---|---|---|---|---|---|
| `neural-network` | [PyTorch Fundamentals](neural-network/01_pytorch_fundamentals.ipynb) | — (synthetic tensors) | Tensor basics: creating, reshaping, indexing, math, one-hot encoding | PyTorch | [![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/akhilmk/neural-network-workbook/blob/main/neural-network/01_pytorch_fundamentals.ipynb) |
| `neural-network` | [Regression](neural-network/02_%20regression.ipynb) | Synthetic `y = x + 10` line + [Medical Insurance](https://raw.githubusercontent.com/stedy/Machine-Learning-with-R-datasets/master/insurance.csv) | Regression: predict a continuous number | PyTorch | [![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/akhilmk/neural-network-workbook/blob/main/neural-network/02_%20regression.ipynb) |
| `neural-network` | [Classification](neural-network/03_classification.ipynb) | Synthetic circles (`make_circles`) + [Fashion-MNIST](https://github.com/zalandoresearch/fashion-mnist) | Classification: binary + multiclass | PyTorch | [![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/akhilmk/neural-network-workbook/blob/main/neural-network/03_classification.ipynb) |
| `neural-network` | [Convolutional Neural Networks](neural-network/04_convolutional_neural_networks.ipynb) | Pizza/Steak + 10 food classes ([Food-101](https://data.vision.ee.ethz.ch/cvl/datasets_extra/food-101/) subsets) | Image classification (CNN): binary + multiclass, augmentation, predictions | PyTorch | [![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/akhilmk/neural-network-workbook/blob/main/neural-network/04_convolutional_neural_networks.ipynb) |
| `fashion-mnist` | [Fashion-MNIST CNN](fashion-mnist/fashion_mnist_cnn.ipynb) | [Fashion-MNIST](https://github.com/zalandoresearch/fashion-mnist) — 60,000 train / 10,000 test, 28×28 grayscale, 10 classes | Image classification (CNN) | PyTorch | [![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/akhilmk/neural-network-workbook/blob/main/fashion-mnist/fashion_mnist_cnn.ipynb) |

> New topics get their own folder and a row in this table. If a folder grows to
> several notebooks, split its rows into a dedicated subsection under **Notebooks**.

## Run locally

```bash
uv sync                 # create the shared .venv from pyproject.toml / uv.lock
uv run jupyter lab      # then open any notebook under a topic folder
```

Datasets are downloaded on first run into `data/` (git-ignored). Trained weights
save as `*.pth` (also git-ignored).

## Run in Colab

Click the **Open in Colab** badge for a notebook. The first cell detects Colab and
installs any missing packages, then the notebook downloads its dataset and runs
end-to-end. No local setup required.

## External references

- [mrdbourke/tensorflow-deep-learning](https://github.com/mrdbourke/tensorflow-deep-learning/tree/main) —
  companion notebooks and course material for the *Zero to Mastery Deep Learning
  with TensorFlow* course. Useful as a second opinion on the same concepts, even
  though its code is TensorFlow/Keras rather than PyTorch.

## Repository layout

```
neural-network-workbook/
├── neural-network/                   # PyTorch fundamentals → regression → classification → CNNs
│   ├── 01_pytorch_fundamentals.ipynb
│   ├── 02_ regression.ipynb
│   ├── 03_classification.ipynb
│   ├── 04_convolutional_neural_networks.ipynb
│   └── saved_models/                 # trained weights (git-ignored)
├── fashion-mnist/                    # CNN image classification
│   ├── fashion_mnist_cnn.ipynb
│   └── README.md                     # notes about this notebook + its dataset
├── scripts/
│   └── check_colab_links.sh          # validates the Colab badges
├── pyproject.toml                    # shared uv environment used by all notebooks
├── uv.lock
├── .python-version
├── data/                             # downloaded datasets (git-ignored)
└── README.md
```

## Adding a new notebook

1. Create a topic folder, e.g. `mnist/`, with your `.ipynb` and a small `README.md`.
2. Add a row to the **Notebooks** table above with its Colab link:
   `https://colab.research.google.com/github/akhilmk/neural-network-workbook/blob/main/<folder>/<notebook>.ipynb`
3. If it needs extra packages, add them to the root `pyproject.toml` and run `uv sync`.

> All notebooks share the single root environment. If a future notebook ever needs
> conflicting dependencies, that topic can be split into its own uv project (or a
> uv workspace) without affecting the others.

## Link checks

Every "Open in Colab" badge must point to a notebook that actually exists.
Validate all of them with:

```bash
scripts/check_colab_links.sh
```

It reports any badge whose path is missing (and warns if a URL points at a
different repo than `origin`). To run it automatically before every push:

```bash
ln -sf ../../scripts/check_colab_links.sh .git/hooks/pre-push
```
