# Test Vector Leakage Assessment

This directory includes the leakage assessment tests and the corresponding hardened implementations for each gadget and masked sampling algorithm. The assessments are performed using a **ChipWhisperer Lite** with an **STM32F303 ARM Cortex-M4** target.

Each gadget has a corresponding Jupyter Notebook driver script and hardened Cortex-M4 assembly implementations under the related ``target`` folder. To install ChipWhisperer on Linux, follow the [installation guide](https://chipwhisperer.readthedocs.io/en/latest/linux-install.html). Gadgets can be placed inside the ``chipwhisperer/jupyter`` directory and run directly from there.

## TVLA Requirements

The TVLA reproduction requires:

- ChipWhisperer Lite
- STM32F303 ARM Cortex-M4 target
- ChipWhisperer Python environment
- ARM GNU Toolchain with `arm-none-eabi-gcc`
- `ipympl` Python package for the Jupyter matplotlib backend

Install `ipympl` inside the ChipWhisperer Python environment:

```
python -m pip install ipympl
```

The TVLA assembly implementations were tested using Arm GNU Toolchain [13.2.Rel1](https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads/13-2-rel1) (arm-none-eabi-gcc 13.2.1). We recommend using this compiler version when reproducing the TVLA notebooks. To check the active compiler version:

```
arm-none-eabi-gcc --version
```

## Running the Notebooks

After installing ChipWhisperer and the required Python packages, place the relevant gadget folder inside ``chipwhisperer/jupyter``. Then open the corresponding Jupyter Notebook from the ChipWhisperer environment and run the cells.
