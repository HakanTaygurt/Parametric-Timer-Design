# Parametric-Timer-Design
FPGA Engineering Challenge: Parametric Timer Design. 



Features
Parametric Design: Customizable clock frequency (clk_freq_hz_g) and delay duration (delay_g).

Math: Uses native VHDL integer division for precise clock cycle calculations without floating-point risks.

Automated Testing: Python-based runner executes multiple test cases automatically.

Self-Checking Testbench: Automatically verifies if the elapsed time matches the expected delay within a tolerance window.

   Prerequisites
To run this project, you need:

Python 3.x

GHDL (Simulator). Note: For Windows, the standalone MinGW/mcode version is recommended.

VUnit (Python library).

Installation
Bash

pip install -r requirements.txt
Ensure that ghdl is accessible in your system PATH or configured in run.py.

   How to Run Tests
Execute the automation script from the root directory:

Bash

python run.py -v
Expected Output: The script will compile the VHDL files and run two test configurations:

100MHz_10us: Validates a 10 us delay at 100 MHz.

10MHz_1ms: Validates a 1 ms delay at 10 MHz.

   Design Decisions
1. Cycle Calculation Logic (RTL)
To determine the number of clock cycles required for the target delay, the design avoids using floating-point arithmetic (e.g., ieee.math_real.ceil).

While ceil offers precise mathematical rounding, using real types can introduce simulation-synthesis mismatches. Therefore, the design relies on VHDL's native strong typing by calculating the period first and using integer division:

VHDL

constant CLK_PERIOD : time := 1 sec / clk_freq_hz_g;
constant CYCLES_REQUIRED : natural := delay_g / CLK_PERIOD;
2. Verification Strategy (Testbench)
Generic Handling: Due to limitations in passing time types via command-line arguments in GHDL/VUnit, the testbench accepts the delay as a natural integer (microseconds). This is internally converted to VHDL time units.

Checks: The testbench captures the simulation time delta between the trigger and completion signals, ensuring the RTL respects the requested delay within a 2-clock-cycle tolerance margin.
