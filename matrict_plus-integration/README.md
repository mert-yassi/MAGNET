# MatRiCT+

This is the implementation source code for the paper:

Muhammed F. Esgin, Ron Steinfeld, & Raymond K. Zhao. (2022). [MatRiCT+: More Efficient Post-Quantum Private Blockchain Payments](https://ia.cr/2021/545). IEEE S&P 2022. DOI https://doi.org/10.1109/SP46214.2022.9833655.

The folder `n10`  is the implementation for anonymity level 1/10.

## Requirements

To compile the source code, the [XKCP](https://github.com/XKCP/XKCP) Keccak library is required.

## Building and Running

Navigate to the `n10` folder:

```bash
cd n10
```

The active sampler can be selected at compilation time.

To compile and run MatRiCT+ with **MAGNET**:

```bash
make magnet && ./ringct
```

To compile and run MatRiCT+ with the **GR19** sampler:

```bash
make gr19 && ./ringct
```

By default, **MAGNET** is used as the discrete Gaussian sampler, so the following command also builds and run the **MAGNET** integration:

```bash
make && ./ringct
```
