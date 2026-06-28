# MAGNET: MAsked Gaussian Now Efficient and Table-less 

This repository provides C and ARM Cortex-M4 reference code for [MAGNET](https://eprint.iacr.org/2026/728), an efficient, table-less masked discrete Gaussian sampler. It also features comparative implementations, integration into the [MatRiCT+](https://gitlab.com/raykzhao/matrict_plus) private payment protocol, and leakage assessment tests for first-order side-channel evaluation.

#### Prerequisites
  - A Linux-based OS
  - `make`
  - `gcc` (tested with version 12.2.0)
  - To plot the distribution: `python3`, `numpy`, `matplotlib`

## C Implementations

**MAGNET** can be compiled and executed in either timing mode or verification mode using the Makefile targets below. The `time` and `verify` Makefile targets select the compilation mode, and the `order` Makefile variable selects the masking order.

* **`time`:** Measures the execution time of the sampler. Use this target to reproduce the performance benchmarks presented in Figure 7.
* **`verify`:** Generates a dataset of raw samples (`samples.txt`). Use this target to plot the distribution and verify the statistical correctness of the outputs.
* **`order`:** The masking order is selected using the `order` variable.

To compile and run **MAGNET** in timing mode with masking order 1:

```bash
make time order=1 && ./MAGNET
```

To compile and run **MAGNET** in verification mode with masking order 1:

```bash
make verify order=1 && ./MAGNET
```

To see the runtimes of unmasked **DP-DGS**, navigate to the DP_DGS folder and execute:

```bash
make && ./DP-DGS
```

To compile and run **GR19-DGS** in timing mode with masking order 1, navigate to the GR19 folder and execute:

```bash
make time order=1 && ./GR19-DGS
```

To compile and run **GR19-DGS** in verification mode with masking order 1, navigate to the GR19 folder and execute:

```bash
make verify order=1 && ./GR19-DGS
```

## MatRiCT+ Integration

The integration of **MAGNET** and **GR19-DGS** into the MatRiCT+ payment protocol can be found in the **matrict_plus-integration** folder. 

### Requirements

To compile the source code, the [XKCP](https://github.com/XKCP/XKCP) Keccak library is required.

### Building and Running

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

By default, **MAGNET** is used as the discrete Gaussian sampler, so the following command also builds and runs the MAGNET integration:

```bash
make && ./ringct
```

## ARM Cortex-M4 Implementation

**MAGNET** ARM Cortex-M4 (Thumb-2 ASM) implementation can be found in **MAGNET_m4** folder. The implementation is built and flashed using **Zephyr** via the **nRF Connect SDK (NCS) v3.1.1**, and evaluated on the **nRF52840 Development Kit**. Other Nordic nRF development kits equipped with an ARM Cortex-M4 CPU should also be compatible.

---

### Requirements

- Linux (recommended)
- Nordic **nrfutil**
- SEGGER J-Link Software and Documentation Pack
- nRF Connect SDK (**NCS**) v3.1.1
- Supported Nordic development kit (for example, `nrf52840dk`)

---

### 1. Installing nrfutil, J-Link, and the NCS v3.1.1 toolchain

The `nrfutil` command-line tool is required to install and manage the nRF Connect SDK toolchain. The SEGGER J-Link Software and Documentation Pack is required for flashing and debugging supported Nordic development kits through Zephyr.

#### 1.1 Download `nrfutil`

Download the latest `nrfutil` executable for Linux (x64) from Nordic Semiconductor’s nRF Util product page:

[https://www.nordicsemi.com/Products/Development-tools/nRF-Util](https://www.nordicsemi.com/Products/Development-tools/nRF-Util)

#### 1.2 Make the executable runnable

After downloading the executable, give it execution permission:

```bash
chmod +x ./nrfutil
```
#### 1.3 Verify the installation

```bash
./nrfutil --version
```

#### 1.4 Install SEGGER J-Link

Download and install the SEGGER J-Link Software and Documentation Pack from:

[https://www.segger.com/downloads/jlink](https://www.segger.com/downloads/jlink)

After installation, verify that the J-Link tools are available:

```bash
JLinkExe
```

#### 1.5 Install the SDK manager command

Install the sdk-manager command for nrfutil:

```bash
./nrfutil install sdk-manager
```

#### 1.6 Install the nRF Connect SDK v3.1.1 toolchain

Install the toolchain corresponding to nRF Connect SDK v3.1.1:

```bash
./nrfutil sdk-manager toolchain install --ncs-version v3.1.1
```

#### 1.7 Launch the nRF Connect SDK toolchain shell

Launch a shell with the toolchain environment for nRF Connect SDK v3.1.1:

```bash
./nrfutil sdk-manager toolchain launch --ncs-version v3.1.1 --shell
```

#### 1.8 Fetch the nRF Connect SDK Workspace

Inside the launched toolchain shell, initialize a new workspace using the official NCS manifest:

```bash
west init -m https://github.com/nrfconnect/sdk-nrf --mr v3.1.1 v3.1.1
cd v3.1.1
west update
```

This step downloads Zephyr and all required NCS components.

Alternatively, after downloading `nrfutil` executable and installing `SEGGER J-Link`, the remaining NCS setup steps can be performed using the provided shell script `zephyr_nRF52840.sh`.

Place `zephyr_nRF52840.sh` and `nrfutil` in the same directory, then run:

```
chmod +x zephyr_nRF52840.sh
./zephyr_nRF52840.sh
```

### 2. Building MAGNET_m4

Copy the **MAGNET_m4** folder into the Zephyr directory of your nRF Connect SDK workspace. Once moved, the path to the project should look like this: ``v3.1.1/zephyr/MAGNET_m4``. Then, navigate to the Zephyr directory and build the application for the nRF52840 development kit:

```
cd v3.1.1/zephyr
west build -b nrf52840dk/nrf52840 MAGNET_m4
```

#### 2.1 Flashing the Firmware

Connect the development kit to the host machine via USB and flash the firmware:

```bash
west flash
```

The command above assumes that the board is supported by the default Zephyr flashing runner and that the SEGGER J-Link Software and Documentation Pack is installed. If `west flash` fails, first check the available flashing runners for the selected board:

```bash
west flash -H
```

For some compatible nRF52840-based boards, such as Makerdiary nRF52840 MDK variants, flashing through `pyOCD` may work better than the default runner. In that case, install `pyOCD` and explicitly select the pyocd runner:

```bash
pip install pyocd
west flash --runner pyocd
```

The required flashing runner may depend on the specific board and debug probe.

#### 2.2 Viewing Output (Optional)

Program output can be monitored using the Serial Terminal provided by the nRF Connect for Desktop application or any compatible serial terminal. Ensure that the correct serial device is selected.

## Test Vector Leakage Assessment

The leakage assessment tests and the corresponding hardened implementations for each gadget and masked sampling algorithm are located in the **TVLA** directory. The assessments are performed using a **ChipWhisperer Lite** with an **STM32F303 ARM Cortex-M4** target.

Each gadget has a corresponding Jupyter Notebook driver script and hardened Cortex-M4 assembly implementations under the related ``target`` folder. To install ChipWhisperer on Linux, follow the [installation guide](https://chipwhisperer.readthedocs.io/en/latest/linux-install.html). Gadgets can be placed inside the ``chipwhisperer/jupyter`` directory and run directly from there.

### TVLA Requirements

The TVLA reproduction requires:

- ChipWhisperer Lite
- STM32F303 ARM Cortex-M4 target
- ChipWhisperer Python environment
- ARM GNU Toolchain with `arm-none-eabi-gcc`
- `ipympl` Python package for the Jupyter matplotlib backend

Install `ipympl` inside the ChipWhisperer Python environment:

```bash
python -m pip install ipympl
```

The TVLA assembly implementations were tested using Arm GNU Toolchain [13.2.Rel1](https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads/13-2-rel1) (arm-none-eabi-gcc 13.2.1). We recommend using this compiler version when reproducing the TVLA notebooks. To check the active compiler version:

```bash
arm-none-eabi-gcc --version
```

### Running the Notebooks

After installing ChipWhisperer and the required Python packages, place the relevant gadget folder inside ``chipwhisperer/jupyter``. Then open the corresponding Jupyter Notebook from the ChipWhisperer environment and run the cells.
