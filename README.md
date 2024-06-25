# Logic Built-In Self Test (LBIST) circuit and Design for Testability addition to a RISC-V Architecure

## About
A Logic Built-In Self Test (LBIST) circuit is an hardware module that enable a device to test itself and automatically detect faults arised inside the architecture. This feature is used along with Design for Testability (DfT) techniques implemented in the architecture itself, increasing significantly the testing capability of complex designs.
The [4-stage RI5CY processor](https://github.com/embecosm/ri5cy) was used as third-party architecture to be modified with DfT insertions and addition of the LBIST circuit.

This project was carried out as *Hardware Assignment* for the course **Testing and Fault Tolerance** at Politecnico di Torino, academic year 2021/2022.

## Tools used
The following tools were used:
+ [Synopsys Design Compiler](https://www.synopsys.com/implementation-and-signoff/rtl-synthesis-test/dc-ultra.html) for synthesis of the RI5CY architecture and automatic Design for Testability insertions (scan chains and test points) and synthesis of the complete architecture (RI5CY + LBIST)
+ [Synopsys TestMAX](https://www.synopsys.com/implementation-and-signoff/rtl-synthesis-test/dc-ultra.html) for fault simulation
+ Modelsim for verification of the complete architecture.

The LBIST circuit was entirely described in **VHDL**.

## Architecture
<p align="center">
  <img src="https://github.com/roberto-dibella-polito/ri5cy_lbist/blob/master/block_diagram.png" width="520">
</p>

The complete architecture is composed of:
+ The RI5CY architecture including DfT inseertions
+ The BIST controller
+ A random Test Pattern Generator
+ A Test Counter
+ An Output Evaluator for error detection.

## Structure of this repository
While the `riscv/` folder includes the implementation of the RI5CY used, the `syn/` folder is structured as follows:
+ `gate/scan/syn/`: folder used for all the gate-level synthesis.
  + `bin/`: scripts used for each synthesis
  + `output/`: files produced by the Design Compiler, along with the gate-level netlists (`riscv_core_scan.v` for basic scan chain, `riscv_core_lbist.v` for the whole architecture
  + `rpt/`: Area and DfT reports
+ `rtl/lbist_blocks/`: contains all RTL descriptions of the design blocks.
