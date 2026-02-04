# The $k=3$ Multifactorial Operator: A Systematic Generative Framework

This repository contains the official implementation and statistical validation of the **$k=3$ Multifactorial Operator**, an algebraic framework for the systematic generation of congruent numbers. This method bypasses traditional rank-computation bottlenecks by using a universal Euclidean parametrization to map a double-entry parametric space $(n, m)$ directly into congruent areas.



## Abstract
This work introduces the polynomial operator $C_{n}^{(k)}(m) = n\prod_{i=1}^{k}(i \cdot n - m)$ for $k=3$. We prove that it admits a universal Euclidean parametrization ($u=2n-m, v=n$), ensuring the generation of Pythagorean areas by construction. Testing against the OEIS A003273 list shows a 100% success rate in local ranges, with modular distributions perfectly aligned with theoretical expectations (residue classes $\{1, 2, 3, 5, 6, 7\} \pmod 8$). Analysis of a $\approx 20$ million record dataset confirms the operator's efficiency in identifying high-magnitude candidates up to $10^{16}$.

## Repository Structure

### 1. Generative Engines (SageMath)
* **`k3_mes.sage.py`**: The standard generative script. It explores the $(n, m)$ space, computes square-free cores, and performs real-time validation against OEIS benchmarks.
* **`k3_mess.sage.py`**: An unrestricted version of the operator used to analyze parametric redundancy and duplication rates, essential for structural robustness tests.

### 2. Statistical Post-Processing (Stata)
* **`Density Stats.do`**: High-precision statistical audit tool. It implements a critical methodological correction by reducing the OEIS A003273 list to its square-free cores for a fair comparison. It validates density against Smith and Tunnell modular bounds.
* **`n Stats.do`**: Performance and distribution analysis for large-scale datasets ($\approx 20.1$ million records). It uses logarithmic sampling to characterize the operator's behavior across high-magnitude parametric ranges (up to $10^{16}$).

### 3. Analytical & Validation Tools (SageMath)
* **`robust_oeis.sage.py`**: Advanced auditor that classifies "Hits," "Misses," and "Excess" (new candidates), automatically testing elliptic curve ranks for new findings.
* **`tunnell_first.sage.py`**: Provides formal algebraic proof by calculating the rank of $y^2 = x^3 - n^2x$ using `mwrank`.
* **`smith_density.sage.py`**: Fast audit of residue classes $\pmod 8$ to ensure alignment with Tunnell’s Theorem.
* **`mn_distribution.sage.py`**: Visualizes the density of the $m/n$ ratio, contrasting the total candidate population against confirmed OEIS hits.
* **`n_max.sage.py`**: A traceability tool that links fundamental cores to their required parametric height.

### 4. Data
* **`lista_608_squarefree.csv`**: A benchmark dataset of 608 validated congruent square-free cores used for auditing.
* *Note: The full 20.1 million record dataset is available upon request or via external storage due to GitHub's size limitations.*

## Requirements
* **SageMath 9.x+**
* **Stata 16+** (for `.do` files)
* Python libraries: `pandas`, `matplotlib`, `requests`

## Support & Collaboration
As an independent researcher, this project is currently self-funded. I am open to sponsorship, academic affiliations, or research grants to support the computational expansion of the $k=3$ Operator framework (e.g., reaching $10^{20}$ ranges). 

**Contact:** [fjlucerob@gmail.com](mailto:fjlucerob@gmail.com)

## License
This project is licensed under the **MIT License** - see the LICENSE file for details.

## Citation
If you use this framework or dataset in your research, please cite:
> Lucero Bravo, F. J. (2026). *The k=3 Multifactorial Operator: A Framework for the Systematic Generation of Congruent Numbers*. Zenodo. DOI: [Insert DOI here]
