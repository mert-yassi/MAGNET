# MAGNET_m4

This folder contains the **MAGNET_m4** implementation targeting Nordic Semiconductor platforms based on an **ARM Cortex-M4** CPU. The implementation is built and flashed using Zephyr via the **nRF Connect SDK (NCS) v3.1.1**, and evaluated on the **nRF52840 Development Kit**. Other Nordic nRF development kits equipped with an ARM Cortex-M4 CPU should also be compatible.

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

The command above assumes that the board is supported by the default Zephyr flashing runner and that the SEGGER J-Link Software and Documentation Pack is installed.

If `west flash` fails, first check the available flashing runners for the selected board:

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



























