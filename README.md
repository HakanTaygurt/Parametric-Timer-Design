
# FPGA Engineering Challenge: Parametric Timer Design

A clean, maintainable, and verifiable VHDL implementation of a parametric timer module. This project is designed to verify functionality through automated Python-based tests (VUnit) and continuous integration.

## 🚀 Features

* **Parametric Design:** Fully customizable via generics for clock frequency (`clk_freq_hz_g`) and delay duration (`delay_g`).
* **Robust Math:** Utilizes native VHDL type conversions for precise clock cycle calculations, ensuring synthesis readiness.
* **Automated Testing:** Powered by **VUnit** and Python to execute multiple test cases automatically.
* **Self-Checking Testbench:** Automatically verifies if the elapsed time matches the expected delay within a strict tolerance window.

##  Prerequisites

To run the verification suite without errors, ensure you have the following installed:

1.  **Python 3.x** (Standard installation)
2.  **GHDL Simulator:**
    * *Linux:* Install via package manager (e.g., `sudo apt install ghdl`).
    * *Windows:* The [MinGW/mcode version](https://github.com/ghdl/ghdl/releases) is recommended.
    * **Important:** Ensure the `ghdl` command is accessible in your system `PATH`.

##  Quick Start & Execution

Follow these steps to run the verification suite immediately:

### 1. Install Dependencies
Open your terminal in the project root and install the VUnit library:

```bash
pip install vunit_hdl
# OR if you prefer requirements file:
# pip install -r requirements.txt

```

### 2. Run the Verification Script

Execute the Python automation script with the verbose flag to see real-time output:

```bash
python run.py -v

```

###  Expected Output

If the environment is set up correctly, you will see the compilation process followed by the test results. Look for the **PASS** confirmation:

```text
...
Compiling src/timer.vhd
Compiling tb/tb_timer.vhd
...
test_runner:100MHz_10us  PASS
test_runner:10MHz_1ms    PASS
...
==== Summary ====================================================================
pass 2 of 2
=================================================================================

```

---

##  Design Decisions & Trade-offs

### 1. Cycle Calculation (RTL)

To determine the precise number of clock cycles required for the target delay, the design handles the conversion between `time` and `natural` types carefully using `ieee.math_real`. This ensures that the timer behaves deterministically across different simulation and synthesis tools.

### 2. Verification Strategy

* **Generic Handling:** The testbench accepts delays as natural integers (microseconds) to bypass command-line limitations, converting them to VHDL time units internally.
* **Tolerance Checks:** The testbench captures the simulation time delta between start and completion, asserting failure if the result deviates by more than 2 clock cycles.

### 3. Formal Verification (Stretch Goal)

An attempt was made to implement **Formal Verification** using **SymbiYosys (SBY)** to mathematically prove the timer's properties (using PSL assertions).

* **Decision:** This module was **excluded** from the final submission.
* **Reasoning:** While the properties were defined, persistent instability in the containerized toolchain (specifically regarding the GHDL-Yosys plugin integration) posed a risk to the reproducibility of the main pipeline. To prioritize a robust, error-free, and cross-platform simulation environment, the focus was shifted entirely to the VUnit verification suite.

```

```
