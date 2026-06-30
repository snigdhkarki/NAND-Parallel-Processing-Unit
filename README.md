# NPPU: A Massively Parallel NAND-Based Logic Processing Unit

High-speed digital circuit simulation faces severe performance bottlenecks on conventional general-purpose CPUs due to the limitations of the Von Neumann architecture. The processing overhead of fetching large 64-bit instructions to compute simple 1-bit logic operations creates a significant bottleneck. While Field Programmable Gate Arrays (FPGAs) provide hardware-level speed, they are constrained by rigid physical routing fabrics and a finite pool of Configurable Logic Blocks (CLBs).

The NAND Parallel Processing Unit (NPPU) addresses these constraints through a specialized architecture that treats individual logic gates as executable instructions. By leveraging high-speed on‑chip memory to store virtualized gate configurations, the NPPU enables highly scalable, ultra‑fast logic verification and emulation.

The underlying system architecture is founded on the principle of **functional completeness**. Because a NAND gate is a universal logic element, any boolean function  
$f: \{0,1\}^n \rightarrow \{0,1\}$  
can be simulated by decomposing a digital circuit netlist into a Directed Acyclic Graph (DAG) of NAND operations.

This was our minor project for bachlors in Computer Engineering and the entire report can be found here: https://drive.google.com/file/d/1KPvnK-krxv_iP-mgzmHoSHE3aAXNJzQA/view?usp=sharing

## Hardware Architecture Overview

The NPPU hardware framework uses a modular Register‑Transfer Level (RTL) approach designed for minimum logic depth to achieve operating frequencies exceeding 200 MHz on target Xilinx Artix‑7 FPGA devices. The layout consists of three primary layers:

- **Instruction Fetch Unit** – Interfaced with a high‑bandwidth memory configuration to deliver parallel instruction streams simultaneously.

- **Execution Array** – A spatial grid composed of 512 single‑bit processing cores that compute up to 512 NAND operations in a single clock cycle. Each individual core contains a 1‑bit accumulator register, a specialized NAND logic unit, and a localized control unit.

- **State Memory (Bit‑Storage)** – A high‑speed, dedicated internal memory block (utilizing 256 KB of FPGA Block RAM) responsible for tracking and updating the active “wire” state values of the simulated circuit.

## Custom 8‑Bit Instruction Set Architecture (ISA)

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

## Testing
<img width="700" height="387" alt="image" src="https://github.com/user-attachments/assets/b12edea6-3f5d-499e-929f-c39a45a44c9e" />

### To make the above circuit we use 4 cores with the following assembly code (which can be converted to Hexadecimal using the assembler)

### Code in Core 1
```
LOADMEM 0
NANDMEM 1
STOREMID 8
NANDCORE 1
STOREOUT 0
HALT
```

### Code in Core 2
```
LOADMEM 2
NANDMEM 3
LOADCORE 1
NANDCORE 2
NANDCORE 3
NANDMEM 8
STOREOUT 1
HALT
```

### Code in Core 3
```
LOADMEM 4
NANDMEM 5
LOADCORE 2
HALT
```

### Code in Core 4
```
LOADMEM 6
NANDMEM 7
LOADCORE 3
LOADCORE 3
NANDCORE 1
STOREOUT 2
HALT
```

We have already used these assemble code to make the Hexadecimal file and kept it in rom1.mem, rom2.mem, rom3.mem and rom4.mem. Now when we run the verilog code using 

```bash
iverilog -o main.out test.v multi.v single_core_for_multi.v multi_rom.v Ram_1_concurrent.v counter.v D_flipflop.v decoder.v MUX_2.v MUX_32.v  Rom_8.v
vvp main.out
```

we get the following output

```
*** Final RAM 1 Contents (Data Memory) ***
Addr 0: 0
Addr 1: 1
Addr 2: 1
Addr 3: 1
Addr 4: 1
Addr 5: 0
Addr 6: 1
Addr 7: 1
Addr 32: 1
Addr 33: 0
Addr 34: 1
Addr 32: 0
Addr 33: 0
Addr 34: 0
Addr 32: 0
Addr 33: 0
```

You can simulate different circuit by writing the assembly code to simulate that circuit and then using assembler on it to make a hex file and putting the hex file in rom{num}.mem file. Some other hexfile that you can use can be found in 
assembler/pastcode.txt


### Single core working mechanism
<img width="442" height="814" alt="image" src="https://github.com/user-attachments/assets/685ebfad-d75d-4e3b-910c-ec5ce909b630" />

### Multicore working mechanism
<img width="646" height="570" alt="image" src="https://github.com/user-attachments/assets/c057b4a2-0a7c-4fea-9380-8a1c93a816e0" />




### Project Contributors

Snigdh Karki (Roll No: 079BCT081) — Department of Electronics & Computer Engineering, Pulchowk Campus.  
Prajwal Kandel (Roll No: 077BCT060) — Department of Electronics & Computer Engineering, Pulchowk Campus.
Suresh Ramtel (Roll No: 079BCT089) — Department of Electronics & Computer Engineering, Pulchowk Campus.  

