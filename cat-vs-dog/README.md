# Cat vs Dog CNN (PyTorch)

[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/akhilmk/neural-network-workbook/blob/main/cat-vs-dog/01_cat_vs_dog.ipynb)

A step-by-step walkthrough of binary image classification with PyTorch: load
100×100 cat/dog images, train a small CNN, evaluate it, and save the weights.

## Dataset

| | |
|---|---|
| **Task** | Binary image classification: dog or cat |
| **Images** | 100×100 RGB |
| **Train** | 2,000 images (1,000 dogs, 1,000 cats) |
| **Test** | 400 images (200 dogs, 200 cats) in the local CSVs |
| **Labels** | `0 = dog`, `1 = cat` |
| **Files** | `input.csv` (~1.4 GB), `labels.csv`, `input_test.csv` (~287 MB), `labels_test.csv` |

### Where the data comes from

The notebook tries three sources in this order:

| Priority | Source | Size | Login | Exact data? |
|---|---|---|---|---|
| 1 | Local `data/cats_vs_dogs/*.csv` | ~1.7 GB | No | ✅ Yes |
| 2 | [Kaggle — Cats & Dogs images](https://www.kaggle.com/datasets/tarekmohamedadel/cats-and-dogs-images) (Apache 2.0) | ~1.8 GB | Optional for public data; recommended | ✅ Yes |
| 3 | Public [`cats_and_dogs_filtered`](https://github.com/MLBasic/cats_and_dogs_filtered) images | ~66 MB | No | ❌ Same task, different images |

The public fallback has 2,000 training and 1,000 validation images, so its score
is not directly comparable to the 400-image local test set.

### Why the CSVs are not committed

- GitHub rejects a single file larger than **100 MB**. `input.csv` is 1.4 GB, so
  a normal push fails.
- Git LFS free tier (1 GB storage / 2 GB bandwidth) does not cover a 1.7 GB
  dataset.
- `data/` and `*.npz` are in `.gitignore`, so the CSVs and the reshaped cache
  cannot be committed by accident.
- Never commit `kaggle.json` or API keys.

### Getting the data in Google Colab

**Option A — exact data from Kaggle (recommended)**

1. On Kaggle, open **Settings → API → Create New Token**. This downloads
   `kaggle.json`.
2. In Colab, either:
   - open **Secrets** (the key icon in the left sidebar) and add
     `KAGGLE_USERNAME` and `KAGGLE_KEY`, or
   - upload `kaggle.json` and move it to `~/.kaggle/kaggle.json`.
3. Run the notebook. `kagglehub` downloads the exact four CSVs, caches them, and
   the notebook reshapes them to 100×100 arrays.

`kagglehub` can often download public datasets anonymously, but credentials are
recommended: they avoid rate limits and keep working if anonymous access changes.

**Option B — no credentials**

Set `USE_KAGGLE = False` in the data-source cell. The notebook downloads the
66 MB public image fallback instead.

**Option C — exact local copy in Colab**

Upload the four CSVs to `data/cats_vs_dogs/`, or mount Google Drive and point
`CSV_DIR` at it. The notebook always prefers `data/cats_vs_dogs/` when all four
files are present.

## What the notebook covers

1. PyTorch image conventions and the data pipeline.
2. Loading the data from local CSVs, Kaggle, or the public fallback.
3. Reshaping `(N, 30000)` → `(N, 100, 100, 3)` → NCHW `(N, 3, 100, 100)`.
4. Scaling **pixels** to `[0, 1]` — never the labels.
5. Building the CNN as an `nn.Module` (1,093,665 parameters).
6. The manual training loop: `zero_grad → forward → loss → backward → step`.
7. Train/test loss and accuracy curves.
8. Classification report, confusion matrix, and a prediction grid.
9. Saving and reloading the `state_dict`.
10. A high-level recap of what matters and what to try next.

## Results

These are the numbers from a verified run using the local
`data/cats_vs_dogs/` CSVs, seed 42, 10 epochs. Notebook outputs are cleared to
keep the file small; run all cells to regenerate the plots.

| Metric | Value |
|---|---|
| Train accuracy (epoch 10) | **89.1%** |
| Test accuracy | **71.0%** |
| Test loss (best / final) | 0.578 (epoch 8) / 0.705 |
| Dog recall | 0.545 (109 / 200) |
| Cat recall | 0.875 (175 / 200) |
| Dog precision | 0.813 |
| Cat precision | 0.658 |
| Trainable parameters | 1,093,665 |
| Runtime | ~80 seconds on CPU |

The train/test gap is the main lesson: train loss keeps falling while test loss
rises after epoch 8. The confusion matrix also shows a bias toward "cat" — 91
dogs are predicted as cats, but only 25 cats are predicted as dogs. Accuracy
alone hides that.

## Run

**Locally** (from the repository root):

```bash
uv sync
uv run jupyter lab
```

The notebook reads `data/cats_vs_dogs/*.csv` if present; otherwise it downloads data.

**In Colab:** click the badge above. Add the Kaggle credentials as described
above for the exact data, or set `USE_KAGGLE = False` for the 66 MB fallback.

## Notes

- **Labels vs pixels:** only the images are divided by 255. Labels stay as
  `0`/`1`; scaling them destroys the targets and silently breaks training.
- **Label mapping:** the CSVs use `0 = dog`, `1 = cat`. `ImageFolder` sorts
  folders alphabetically (`cats = 0`, `dogs = 1`), so the fallback flips labels
  with `target_transform` to preserve the same convention.
- **Shuffle:** the CSV rows are ordered (1,000 dogs, then 1,000 cats). The
  training loader uses `shuffle=True` and a seeded generator, so every batch
  contains both classes and runs are reproducible.
- **Cache:** the first CSV read creates `data/cats_vs_dogs/input_100px.npz` and
  `input_test_100px.npz` (~48 MB + ~10 MB). Reruns load in under a second.
- **Weights:** saved to `cat-vs-dog/saved_models/cat_dog_cnn.pth`, ignored by
  `*.pth`.

