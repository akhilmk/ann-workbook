# AGENTS.md

Instructions for AI coding agents working in this repository. The human-facing
overview is in [README.md](README.md).

## What this repo is

A collection of self-contained PyTorch learning notebooks. Each topic lives in its
own folder (`neural-network/`, `fashion-mnist/`), and the root README table is the
index. **The notebooks are the deliverable** — this is not a Python package.

## Environment

- Python 3.12; dependencies are managed with [uv](https://docs.astral.sh/uv/).
- Use `uv sync` to install and `uv run …` to execute tools (for example,
  `uv run jupyter lab`).
- Do not use `pip install`, create another virtualenv, or add per-folder projects.
- Add new dependencies to the root `pyproject.toml`, then run `uv sync` so
  `uv.lock` stays current.

## Notebook rules

- Preserve the existing cell order, markdown explanations, and teaching style.
- Do not convert notebook cells into `.py` files or reformat notebooks wholesale.
- Do not clear the committed outputs of `fashion-mnist/fashion_mnist_cnn.ipynb`.
- Keep notebooks runnable top-to-bottom, both locally and in Colab. If a notebook
  needs a package Colab may lack (e.g. `torchinfo`), include the Colab bootstrap
  pattern used in the Fashion-MNIST notebook.
- Name new notebooks `NN_topic.ipynb` without spaces. `02_ regression.ipynb` is a
  known exception — do not rename it unless asked.
- Run notebooks or training only when the task requires it; full training is slow.
  Prefer executing targeted cells, and avoid committing large new outputs.

## Generated files

Never commit:

- datasets: `data/`, `**/data/`
- trained weights: `*.pth`, `saved_models/`
- `.venv/`, `__pycache__/`, `.ipynb_checkpoints/`

## README and Colab links

- A new notebook needs a row in the root README table and a Colab badge using:
  `https://colab.research.google.com/github/akhilmk/neural-network-workbook/blob/main/<folder>/<notebook>.ipynb`
- URL-encode spaces in badge URLs (`%20`); use a normal relative link for the
  notebook name in the table.
- After changing any README with a badge, run `scripts/check_colab_links.sh`.
  It must report `0 broken, 0 warnings`.
- Keep the README's repository-layout block and "Adding a new notebook" steps
  accurate when the structure changes.

## Known inconsistencies

- `pyproject.toml` still names the project `ann-workbook` while the repository is
  `neural-network-workbook`. Leave it unless the user asks to rename it.
- `neural-network/` has no folder-level README yet; add one when the folder grows.

## Scope

Make the smallest change that solves the task. Do not reorganize folders, rename
topics, or add linting/CI/tooling unless requested. Ask before deleting or
rewriting user-authored notebook content, and do not commit or push unless asked.
