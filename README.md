# MAGNET: MAsked Gaussian Now Efficient and Table-less 

This repository provides reference implementations of **MAGNET**, a table-less and efficient masked discrete Gaussian sampler, along with comparative implementations. It includes C and ARM Cortex-M4 implementations, integrations of the masked samplers into [MatRiCT+](https://gitlab.com/raykzhao/matrict_plus) private payment protocol, and leakage assessment artifacts for first-order side-channel evaluation.

#### Prerequisites
  - A Linux-based OS
  - `make`
  - `gcc` (tested with version 12.2.0)
  - To plot the distribution: `python3`, `numpy`, `matplotlib`

## C Implementations

**MAGNET** can be compiled and executed with:

``make && ./MAGNET``

You can evaluate the MAGNET sampler using two different directives. To switch between them, simply open the `params.h` file and uncomment your desired directive. 

* **`TIME`:** Measures the execution time of the sampler. Use this directive to reproduce the performance benchmarks presented in Figure 7. The masking order can be changed by modifying the 'NUM_SHARES' variable in `params.h`.
* **`VERIFY`:** Generates a dataset of raw samples (`samples.txt`). Use this directive to plot the distribution and verify the statistical correctness of the outputs.

To see the runtimes of unmasked **DP-DGS**, under the DP_DGS folder, execute:

``make && ./DP-DGS``

To see the runtimes of **GR19-DGS**, under the GR19 folder, execute:

``make && ./GR19-DGS``

## MatRiCT+ Integration

The integration of **MAGNET** and **GR19-DGS** into the MatRiCT+ payment protocol can be found in the **matrict_plus-integration** folder. To run the implementation, navigate to the **n10** folder and execute:

``make && ./ringct``

By default, **MAGNET** is used as the discrete Gaussian sampler. The active sampler can be changed by modifying the corresponding #define directive in the `n10/param.h` file. Run ``make clean && make && ./ringct`` after changing any directives.

## ARM Cortex-M4 Implementation

MAGNET ARM Cortex-M4 (Thumb-2 ASM) implementation can be found in **MAGNET_m4** folder. The procedure for running the implementation using **nrfutil** is described in the README under this folder.

## Test Vector Leakage Assessment

The leakage assessment tests and the corresponding hardened implementations for each gadget and masked sampling algorithm are located in the **TVLA** directory.
