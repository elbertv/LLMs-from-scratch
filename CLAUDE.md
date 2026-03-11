# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Official code repository for the Manning book *Build a Large Language Model (From Scratch)* by Sebastian Raschka. Implements GPT-like LLMs from scratch using pure PyTorch — no HuggingFace Transformers for core implementations. Includes pretraining, text classification finetuning, and instruction finetuning, plus alternative architectures (Llama 3, Qwen3, Gemma 3, MoE, GQA, MLA, DeltaNet).

## Environment Setup

```bash
# Install core dependencies
pip install -r requirements.txt

# Or with uv (preferred for development)
uv sync --dev

# Install the local package in editable mode
pip install -e .

# Install bonus dependencies (transformers, chainlit, etc.)
uv pip install --group bonus
```

## Commands

### Running Tests

```bash
# Run all package tests
pytest pkg/llms_from_scratch/tests/

# Run a specific test file
pytest pkg/llms_from_scratch/tests/test_ch04.py

# Run chapter-specific tests
pytest ch04/01_main-chapter-code/tests.py
pytest ch05/01_main-chapter-code/tests.py

# Test a Jupyter notebook
pytest --nbval ch03/01_main-chapter-code/multihead-attention.ipynb

# Run with pixi (conda-forge)
pixi run -e tests pytest
```

### Linting

```bash
ruff check .
ruff format .
```

## Code Architecture

### Repository Structure

The repo is organized chapter-by-chapter, mirroring the book:
- `ch02/` — Tokenization and DataLoaders
- `ch03/` — Attention mechanisms (self → multi-head → causal)
- `ch04/` — Full GPT model architecture
- `ch05/` — Pretraining pipeline, weight loading, model variants (Llama 3, Qwen3, Gemma 3)
- `ch06/` — Text classification finetuning
- `ch07/` — Instruction finetuning and DPO
- `appendix-*/` — PyTorch intro, LoRA, training loop enhancements
- `pkg/llms_from_scratch/` — Importable PyPI package of all key implementations

Each chapter directory follows the pattern:
- `01_main-chapter-code/` — Primary notebooks and scripts
- `0N_bonus_*/` — Supplementary material and experiments

### PyPI Package (`pkg/llms_from_scratch/`)

The package exposes importable modules mirroring book chapters:
- `ch02.py` – Data loading utilities
- `ch03.py` – 7 attention mechanism implementations
- `ch04.py` – GPT architecture components
- `ch05.py` – Training loop, text generation, weight loading (14 functions)
- `ch06.py` – Classification head utilities
- `ch07.py` – Instruction finetuning utilities
- `appendix_d.py` – Training loop enhancements (cosine decay, warmup, gradient clipping)
- `appendix_e.py` – LoRA finetuning
- `generate.py` – Text generation with KV cache variants
- `kv_cache/`, `kv_cache_batched/` – Optimized inference modules
- `llama3.py`, `qwen3.py` – Alternative model architectures

### Key Implementation Files

| File | Purpose |
|------|---------|
| `ch04/01_main-chapter-code/gpt.py` | Core GPT model (GPTModel, TransformerBlock, MultiHeadAttention, etc.) |
| `ch05/01_main-chapter-code/gpt_train.py` | Training loop |
| `ch05/01_main-chapter-code/gpt_download.py` | Download pretrained GPT-2 weights |
| `pkg/llms_from_scratch/llama3.py` | Llama 3 architecture |
| `pkg/llms_from_scratch/qwen3.py` | Qwen3 architecture |

### Architecture Patterns

- **Device-agnostic**: All models support CPU/CUDA/MPS via `torch.device`
- **No LLM libraries**: Core models use only PyTorch primitives for educational clarity
- **Multiple variants per concept**: e.g., standard `MultiHeadAttention` alongside `MultiHeadAttentionCombinedQKV`, `MHAPyTorchScaledDotProduct`, etc.
- **KV cache**: Available in `generate.py` and dedicated `kv_cache/` modules for inference optimization
- **LoRA**: Implemented in `appendix_e.py` with `LinearWithLoRA` and `MultiHeadAttentionWithLoRA`

## Dependencies

- **torch** ≥2.2.2 (core), **tiktoken** (tokenization), **numpy**, **matplotlib**, **pandas**, **tqdm**
- Dev: **pytest**, **ruff**, **nbval**
- Bonus: **transformers**, **huggingface_hub**, **safetensors**, **chainlit**, **openai**, **scikit-learn**

## CI/CD

GitHub Actions tests run across Linux/macOS/Windows, Python 3.10–3.13, PyTorch stable/RC/old versions. See `.github/workflows/` for test matrix details.

## Git

Every time you make a change to the code, without exception, you will run:

```bash
git add .
git commit -m "{descriptive comment} YYYY_MM_DD_HH_MM"
```

Where `YYYY_MM_DD_HH_MM` is the exact system date and time at the moment of the change.

- Never run `git push` or `git pull`. That is the developer's responsibility.
- Do not worry about branches; the developer manages them.

---

## Code Style (Python)

All code you write must strictly follow:

- **Clean Code** (Robert C. Martin): readable, simple, and duplication-free.
- **Zen of Python** (`import this`): explicit over implicit, simple over complex.

### Functions

- Each function has **one single responsibility**.
- Each function has its **NumPy-style docstring**, with all parameters documented and typed.
- All parameters must be **type-annotated** (`def fn(x: int) -> str:`).
- Function and variable names must be **clear and self-descriptive**, minimizing the need for comments.
- **Explanatory comments** are allowed and expected when the logic requires it.

### Files and Classes

- Each **file** must have its own docstring at the top describing its purpose.
- Each **class** must have its own docstring describing its responsibility.

### Expected Structure Example

```python
"""
module: data_loader.py
Loads and validates data files from the local file system.
"""


class DataLoader:
    """
    Loads data files in CSV or Parquet format.

    Attributes
    ----------
    file_path : str
        Path to the data file.
    """

    def __init__(self, file_path: str) -> None:
        self.file_path = file_path

    def load(self) -> pd.DataFrame:
        """
        Reads the file and returns a DataFrame.

        Returns
        -------
        pd.DataFrame
            Data loaded from the file.

        Raises
        ------
        FileNotFoundError
            If the file does not exist at the given path.
        """
        ...
```