# CLC Simulations

This repository contains simulation models, analysis scripts, and manuscript materials for a study investigating evolution in species with complex life cycles (CLCs). The codebase is actively under development; expect egregious errors.

## Repository Structure

- **`data/`**
  - **`raw/`**: Original SLiM simulation outputs (unprocessed).
  - **`processed/`**: Data processed or summarized for analyses and figure generation.

- **`figs/`**: Go figure.

- **`scripts/`**
  - **`slim/`**: Simulation scripts for SLiM models.
  - **`analysis/`**: Post-processing and statistical analysis scripts (R and Python).
  - **`slurm/`**: SLURM scripts for managing computational cluster jobs.

- **`tex/`**: LaTeX documents for manuscript preparation.
  - Main manuscript and bibliography files.

## Usage Notes

- Ensure you use the scripts in the specified order: SLiM simulations (`scripts/slim/`), followed by analysis (`scripts/analysis/`).
- Figures and processed data used in the manuscript are stored separately in clearly labeled directories.
