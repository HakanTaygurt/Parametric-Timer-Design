AI Usage Disclosure
In compliance with the project submission guidelines, this document details the use of AI assistants during the development lifecycle of this project.

1. Tools Used
Large Language Models (ChatGPT / Claude): Used strictly as a reference for documentation lookup, environment troubleshooting, and syntax verification.

2. Scope of Usage
RTL Implementation (VHDL)
Manual Work: The core timer logic, state machine architecture, and signal management in src/timer.vhd were designed and implemented manually to ensure full compliance with the entity interface specified in the challenge document.

AI Assistance: AI was used to verify specific VHDL-2008 syntax details, particularly regarding the mathematical type conversion logic (converting time input to natural cycle counts using ieee.math_real), ensuring the code remained synthesis-ready.

Verification (VUnit)
Manual Work: Defined the test plan, edge cases (e.g., reset behavior while counting, busy flag logic), and assertion criteria.

AI Assistance: Utilized AI to generate the initial boilerplate structure for the VUnit run.py configuration script and to quickly reference the VUnit logging API documentation.

DevOps & Environment (Docker/CI)
Manual Work: Defined the Continuous Integration strategy and workflow requirements.

AI Assistance: AI was leveraged to troubleshoot environment-specific errors within the Docker container, specifically related to library dependencies for the GHDL simulator.

Formal Verification (Stretch Goal)
Note: AI was consulted to help configure the SymbiYosys (SBY) toolchain for the optional formal verification task. However, due to toolchain instability within the containerized environment, I made the engineering decision to exclude this optional module from the final submission to prioritize a clean, error-free, and robust simulation environment.

3. Verification of AI Output
To ensure the integrity of the code, all AI-generated suggestions were validated through the following methods:

Specification Compliance: I manually reviewed all interface signals and generics against the provided PDF specifications to ensure strict adherence to naming conventions and data types.

Simulation-Based Testing: No code snippet was accepted without passing the local VUnit test suite (python3 run.py -v).

Code Review: I performed a line-by-line review of the AI-suggested syntax corrections to ensure they aligned with industry-standard VHDL coding practices.
