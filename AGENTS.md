# AGENTS.md

Instructions for AI coding agents working in this repository. The human-facing
overview is in [README.md](README.md).

## Git: hands off

Never run git commands. The user reviews diffs, stages, commits, and pushes
manually.

- Do not run `git add`, `git commit`, `git push`, `git diff`, `git status`,
  `git log`, `git checkout`, `git switch`, `git reset`, `git restore`,
  `git stash`, `git branch`, `git tag`, `git merge`, `git rebase`, or
  `git pull`.
- Do not create, amend, or rewrite commits, and do not change branches or
  remotes.
- Do not use `git` to inspect the working tree or history; read files directly
  with normal file tools.
- When a change is ready, stop and report the modified files. Mention that a
  commit may be needed, but leave all git work to the user.
- Even if a request appears to ask for a git operation, do not run it. Remind the
  user of this rule and let them perform it themselves.

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

## Local + Colab parity

Every notebook must run end-to-end in **both** places:

- Locally with `uv run jupyter lab`; dependencies come from `uv sync`.
- In Colab via the README badge. Colab ships torch, torchvision, numpy, pandas,
  matplotlib, seaborn, and scikit-learn, but not smaller extras such as
  `torchinfo`.

Rules:

- The top import cell must install anything Colab lacks. Guard the install so it
  is a no-op locally and only runs when the package is actually missing:

  ```python
  import sys

  if "google.colab" in sys.modules:
      try:
          import torchinfo  # noqa: F401
      except ModuleNotFoundError:
          import subprocess
          subprocess.run(
              [sys.executable, "-m", "pip", "-q", "install", "torchinfo"],
              check=True,
          )
  ```

- The Fashion-MNIST and Regression notebooks are the reference examples.
- Do not use bare `!pip install` lines, because they also run in local
  environments.
- When adding a dependency to `pyproject.toml`, check whether Colab already ships
  it; if not, add it to the notebook's bootstrap cell too.
- Avoid assumptions about the working directory in code that must work in both
  places; resolve paths from the notebook or repository root when needed.

## Notebook rules

- Preserve the existing cell order, markdown explanations, and teaching style.
- Do not convert notebook cells into `.py` files or reformat notebooks wholesale.
- Do not clear the committed outputs of `fashion-mnist/fashion_mnist_cnn.ipynb`.
- Keep notebooks runnable top-to-bottom in both environments — see
  [Local + Colab parity](#local--colab-parity).
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
rewriting user-authored notebook content. Leave every git operation to the user
— see [Git: hands off](#git-hands-off).
