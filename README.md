# ann-workbook

A collection of **CNN learning notebooks** in PyTorch. Each topic lives in its own
folder and is self-contained, so you can run any notebook:

- **Locally** with [uv](https://docs.astral.sh/uv/) — one shared environment, no setup scripts.
- **In the cloud** with **Open in Colab** — datasets download automatically, nothing to install.

## Notebooks

| Notebook | Dataset | Task | Framework | Colab |
|---|---|---|---|---|
| [Fashion-MNIST CNN](fashion-mnist/cnn-pt.ipynb) | [Fashion-MNIST](https://github.com/zalandoresearch/fashion-mnist) — 60,000 train / 10,000 test, 28×28 grayscale, 10 classes | Image classification (CNN) | PyTorch | [![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/akhilmk/ann-workbook/blob/main/fashion-mnist/cnn-pt.ipynb) |

> More notebooks (MNIST, CIFAR-10, …) will be added here as new folders with a row in this table.

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

## Repository layout

```
ann-workbook/
├── fashion-mnist/            # one folder per topic
│   ├── cnn-pt.ipynb          # the notebook
│   └── README.md             # notes about this notebook + its dataset
├── pyproject.toml            # shared uv environment used by all notebooks
├── uv.lock
├── .python-version
├── data/                     # downloaded datasets (git-ignored)
└── README.md
```

## Adding a new notebook

1. Create a topic folder, e.g. `mnist/`, with your `.ipynb` and a small `README.md`.
2. Add a row to the **Notebooks** table above with its Colab link:
   `https://colab.research.google.com/github/akhilmk/ann-workbook/blob/main/<folder>/<notebook>.ipynb`
3. If it needs extra packages, add them to the root `pyproject.toml` and run `uv sync`.

> All notebooks share the single root environment. If a future notebook ever needs
> conflicting dependencies, that topic can be split into its own uv project (or a
> uv workspace) without affecting the others.
