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

The integration of **MAGNET** and **GR19-DGS** into the MatRiCT+ payment protocol can be found in the **matrict_plus-integration** folder. In order to compile the source code, you need [XKCP](https://github.com/XKCP/XKCP) i.e., extended Keccak library.

To run the implementation, navigate to the **n10** folder and execute:

``make && ./ringct``

By default, **MAGNET** is used as the discrete Gaussian sampler. The active sampler can be changed by modifying the corresponding #define directive in the `n10/param.h` file. Run ``make clean && make && ./ringct`` after changing any directives.

## ARM Cortex-M4 Implementation

MAGNET ARM Cortex-M4 (Thumb-2 ASM) implementation can be found in **MAGNET_m4** folder. The implementation is built and flashed using **Zephyr** via the **nRF Connect SDK (NCS) v3.1.1**.

We evaluated it on the **nRF52840 Development Kit**. Other Nordic nRF development kits equipped with an ARM Cortex-M4 CPU should also be compatible.

---

### Requirements

- Linux (recommended)
- Nordic **nrfutil**
- nRF Connect SDK (**NCS**) v3.1.1
- Supported Nordic development kit (for example, `nrf52840dk`)

---

### 1. Installing `nrfutil`

The `nrfutil` command-line tool is required to install and manage the nRF Connect SDK toolchain.

#### 1.1 Download `nrfutil`

Download the latest standalone `nrfutil` binary from Nordic Semiconductor’s official GitHub releases page:

[https://github.com/NordicSemiconductor/nrfutil/releases]

#### 1.2 Extract and install

Extract the archive and move the `nrfutil` binary to a directory included in your `PATH`:

```
tar -xvf nrfutil-linux-x86_64.tar.gz
chmod +x nrfutil
sudo mv nrfutil /usr/local/bin/
```
#### 1.3 Verify the installation

```
nrfutil --version
```

#### 1.4 Launching the nRF Connect SDK Toolchain

Once nrfutil is installed, launch a shell with the toolchain corresponding to nRF Connect SDK v3.1.1:

```
nrfutil sdk-manager toolchain launch --ncs-version v3.1.1 --shell
```

#### 1.5 Fetching the nRF Connect SDK Workspace

Initialize a new workspace using the official NCS manifest:

```
west init -m https://github.com/nrfconnect/sdk-nrf --mr v3.1.1 v3.1.1
cd v3.1.1
west update
```

This step downloads Zephyr and all required NCS components.

### 2. Building MAGNET_m4

Copy **MAGNET_m4** folder inside the Zephyr directory of your nRF Connect SDK (NCS) workspace. Once moved, the path to the project should look like this: ``ncs/v3.1.1/zephyr/MAGNET_m4``. Then, navigate to the Zephyr directory and build the application for the nRF52840 development kit:

```
cd ncs/v3.1.1/zephyr
west build -b nrf52840dk/nrf52840 MAGNET_m4
```

#### 2.1 Flashing the Firmware

Connect the development kit to the host machine via USB and flash the firmware:

```
west flash
```

#### 2.2 Viewing Output (Optional)

Program output can be monitored using the Serial Terminal provided by the nRF Connect for Desktop application or any compatible serial terminal. Ensure that the correct serial device is selected.

## Test Vector Leakage Assessment

The leakage assessment tests and the corresponding hardened implementations for each gadget and masked sampling algorithm are located in the **TVLA** directory. The assessments are performed using a Chipwhisperer Lite STM32F303 capturer with an ARM Cortex-M4 target. Each gadget has the corresponding Jupyter Notebook driver script and hardened Cortex-M4 assembly implementations under the related ``target`` folder. To install Chipwhisperer on Linux, follow the [installation guide](https://chipwhisperer.readthedocs.io/en/latest/linux-install.html). Gadgets can be placed inside the ``chipwhisperer/jupyter`` directory and run directly from there.
