# The $k=3$ Multifactorial Operator Framework

This repository contains the computational framework, datasets, and interactive tools supporting the manuscript: **"The $k=3$ Multifactorial Operator: A Framework for the Systematic Generation of Congruent Numbers"**.

## Abstract
This work introduces a novel algebraic operator, $C_{n}^{(3)}(m) = n(n-m)(2n-m)(3n-m)$, designed for the systematic generation of congruent number candidates. We prove a universal mapping to Euclidean parameters ($u=2n-m, v=n$), enabling an exhaustive exploration of the parametric space $1 < u/v < 2$. The framework is validated through a 12.4M record audit, demonstrating a stable platykurtic distribution and modular alignment with Tunnell’s criteria.

## 🚀 Interactive Visualization
The repository includes an interactive dashboard (`index.html`) developed in p5.js and Math.js. This tool allows real-time exploration of the $k=3$ operator:
* **Real-time Parametric Mapping**: Visualize the transformation from $(n, m)$ to Euclidean $(u, v)$ space.
* **Theorem Verification**: Instant validation of Theorem 10 (SF Invariant) and Lemma 4 (Inheritance Property).
* **Modular Dashboard**: Live monitoring of residue classes and square-free core reduction.
* **How to use**: Simply open `index.html` in any modern web browser.

## Repository Structure

### 1. Core Theorems & Verification
* **`codigo3_analisis_complementarios.sage.py`**: Validation suite for universal Euclidean mapping and boundary conditions ($m = n-1$).
* **`espacio_parametrico_uv.csv`**: Mapping dataset validating the $1 < u/v < 2$ ratio range.
* **`verificacion_frontera.csv`**: Numerical proof of operator convergence to oblong forms.
* **`verificacion_invariante_sf.csv`**: Documentation of square-free core invariance across scaled parameters.

### 2. Statistical & Modular Analysis
* **`codigo2_analisis_modular.sage.py`**: Extensive residue analysis (mod 3, 8, 24) for the 12.4M dataset.
* **`k3_mhalf.sage.py`**: Implementation of the $m = n/2$ regime (rational median form).
* **`k3_mhalfminus1.sage.py`**: Exploration of non-linear parametric shifts and modular impacts.
* **`maxmin_minusplus_half.sage.py`**: Comparative analysis of coverage across distinct parametric routes.

### 3. OEIS Benchmarking & Robustness
* **`OEIS_10k_CORRECTED.sage.py`**: Primary validation script against OEIS A003273.
* **`k32500_oeiscoverage_robust.sage.py`**: Aggregate census of unique square-free cores across multiple regimes.
* **`k32500_oeiscoverage_robust.sage.py`**: Robust integration for global census of unique cores.
* **`direct_rawcov.sage.py`**: High-speed auditing for direct identity matches ($N = \text{OEIS}$).

### 4. Discovery & High-Scale Results
* **`23.sage.py`**: Targeted seed-hunter algorithm for specific congruent numbers.
* **`rank_12routes.sage.py`**: Automated rank calculation for generated elliptic curves $y^2 = x^3 - n^2x$.
* **`highmagnitude_results.sage.py`**: Log of candidates $N > 10^{12}$ and their generative paths.
* **`k3_mes.sage.py` / `k3_mess.sage.py`**: High-performance exploration scripts with redundancy filtering.

## Technical Requirements
* **SageMath 9.0+** / **Python 3.x**
* **p5.js** (included via CDN in `index.html`)
* **Pandas & Scipy** (for statistical modules)

## Citation
If you use this framework or the $k=3$ operator in your research, please cite:
*Lucero Bravo, F. J. (2026). The $k=3$ Multifactorial Operator: A Framework for the Systematic Generation of Congruent Numbers.*

