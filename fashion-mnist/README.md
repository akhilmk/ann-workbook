# Fashion-MNIST CNN (PyTorch)

[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/akhilmk/neural-network-workbook/blob/main/fashion-mnist/fashion_mnist_cnn.ipynb)

A step-by-step walkthrough of **image preprocessing** and training a
**Convolutional Neural Network** on Fashion-MNIST, using PyTorch.

## Dataset

| | |
|---|---|
| **Name** | [Fashion-MNIST](https://github.com/zalandoresearch/fashion-mnist) (Zalando Research) |
| **Samples** | 60,000 train / 10,000 test |
| **Images** | 28×28 grayscale (1 channel) |
| **Classes** | 10 — T-shirt/top, Trouser, Pullover, Dress, Coat, Sandal, Shirt, Sneaker, Bag, Ankle boot |
| **Balance** | 6,000 images per class (training) |
| **Source** | Downloaded automatically via `torchvision`, or loaded from the Kaggle CSVs if present |

## What the notebook covers

1. Loading data (Kaggle CSVs with a `torchvision` download fallback)
2. Visualising the class distribution
3. Preprocessing: reshape, normalize (`/255`), and add the channel dimension
   (NCHW, unlike Keras' NHWC)
4. Splitting into train/validation and building `DataLoader`s
5. Defining the CNN as an `nn.Module`
6. Training loop with early stopping on validation loss
7. Accuracy/loss curves, true-vs-predicted grid, classification report, and confusion matrix
8. Saving and reloading the trained weights

## Results

| Metric | Value |
|---|---|
| Best validation accuracy | ~93.4% |
| Test accuracy | **92.6%** |
| Early stopping | halted at epoch 36 (`patience=18`, best val_loss at epoch 18) |
| Model size | ~577 K parameters |

## Run

**Locally** (from the repository root):

```bash
uv sync
uv run jupyter lab
```

**In Colab:** click the badge above. The first cell installs any missing packages
and the notebook downloads its dataset automatically.

### Notes

- Data is written to `../data/` (the repository root, git-ignored).
- Weights are saved as `../fashion_cnn.pth`.
- `seaborn`'s `countplot` miscounts categoricals under pandas 3.0, so the
  distribution plots aggregate with `value_counts()` and render with `barplot`.

## References

- [How to preprocess and train a CNN step by step](https://www.kaggle.com/code/vesuvius13/how-to-preprocess-and-train-a-cnn-step-by-step)
  — the original TensorFlow/Keras notebook this PyTorch walkthrough is ported
  from.
- [Fashion-MNIST dataset](https://github.com/zalandoresearch/fashion-mnist) —
  Zalando Research.
