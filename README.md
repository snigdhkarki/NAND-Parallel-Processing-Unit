# NPPU: A Massively Parallel NAND-Based Logic Processing Unit

High-speed digital circuit simulation faces severe performance bottlenecks on conventional general-purpose CPUs due to the limitations of the Von Neumann architecture. The processing overhead of fetching large 64-bit instructions to compute simple 1-bit logic operations creates a significant bottleneck. While Field Programmable Gate Arrays (FPGAs) provide hardware-level speed, they are constrained by rigid physical routing fabrics and a finite pool of Configurable Logic Blocks (CLBs).

The NAND Parallel Processing Unit (NPPU) addresses these constraints through a specialized architecture that treats individual logic gates as executable instructions. By leveraging high-speed on‑chip memory to store virtualized gate configurations, the NPPU enables highly scalable, ultra‑fast logic verification and emulation.

The underlying system architecture is founded on the principle of **functional completeness**. Because a NAND gate is a universal logic element, any boolean function  
$f: \{0,1\}^n \rightarrow \{0,1\}$  
can be simulated by decomposing a digital circuit netlist into a Directed Acyclic Graph (DAG) of NAND operations.

## 🏗️ Hardware Architecture Overview

The NPPU hardware framework uses a modular Register‑Transfer Level (RTL) approach designed for minimum logic depth to achieve operating frequencies exceeding 200 MHz on target Xilinx Artix‑7 FPGA devices. The layout consists of three primary layers:

- **Instruction Fetch Unit** – Interfaced with a high‑bandwidth memory configuration to deliver parallel instruction streams simultaneously.

- **Execution Array** – A spatial grid composed of 512 single‑bit processing cores that compute up to 512 NAND operations in a single clock cycle. Each individual core contains a 1‑bit accumulator register, a specialized NAND logic unit, and a localized control unit.

- **State Memory (Bit‑Storage)** – A high‑speed, dedicated internal memory block (utilizing 256 KB of FPGA Block RAM) responsible for tracking and updating the active “wire” state values of the simulated circuit.

## 💻 Custom 8‑Bit Instruction Set Architecture (ISA)

The custom instruction word is tightly packed into a single 8‑bit byte to maximize execution density and minimize memory overhead. The byte layout splits into a **3‑bit Opcode** and a **5‑bit Operand Address**:

- Bits [7:5] – 3‑bit Opcode specifying the target operation.
- Bits [4:0] – 5‑bit Operand value (address space masked to `0x1F`).

### Instruction Opcodes

| Instruction | Opcode (Binary) | Description |
|-------------|----------------|-------------|
| `NANDMEM`   | `000`          | Executes a NAND operation between the core register accumulator and the bit stored at the specified memory address. |
| `NANDCORE`  | `001`          | Executes a NAND operation between the internal core accumulator and another target core register's state. |
| `STOREMID`  | `010`          | Writes the current register value out to an intermediate mid‑state bit storage address. |
| `STOREOUT`  | `011`          | Writes the final core register output bit to the designated external system output address. |
| `LOADMEM`   | `100`          | Loads an active bit value directly from memory into the 1‑bit core accumulator register. |
| `LOADCORE`  | `101`          | Loads a bit value directly from a core or internal state register tracking block. |
| `HALT`      | `111` (`0xFF`) | Signals the core that execution is complete and stops the execution routine. |
