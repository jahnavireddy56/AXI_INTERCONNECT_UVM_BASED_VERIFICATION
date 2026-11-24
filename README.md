# AXI_INTERCONNECT_UVM_BASED_VERIFICATION
# AXI4 Interconnect Verification using SystemVerilog and UVM

## 📌 Project Overview

This project focuses on the functional verification of an **AXI4 Interconnect connecting 2 Masters and 3 Slaves** using SystemVerilog and Universal Verification Methodology (UVM).

The AXI4 interconnect enables multiple masters to communicate with multiple slaves by decoding addresses, arbitrating requests, routing transactions, and returning responses to the requesting masters.

The primary objective is to verify protocol compliance, address routing, data integrity, transaction ordering, and response handling across all five independent AXI4 channels.

## 🎯 Project Objectives

- Verify connectivity between 2 AXI4 Masters and 3 AXI4 Slaves.
- Verify read and write transactions.
- Validate address decoding and transaction routing.
- Verify FIXED, INCR, and WRAP burst transactions.
- Check VALID/READY handshake functionality.
- Verify multiple outstanding transactions.
- Verify out-of-order transaction handling.
- Validate all four AXI response types.
- Verify reset behavior and data integrity.
- Achieve functional coverage closure.

## 🏗️ System Architecture

**Interconnect Configuration:**
- Number of Masters: 2
- Number of Slaves: 3
- Protocol: AMBA AXI4
- Data Bus Width: 32 bits
- Address Bus Width: 32 bits
- Transaction ID Width: 8 bits

### Block Diagram

```text
       AXI MASTER 0          AXI MASTER 1
            |                     |
            |                     |
            +----------+----------+
                       |
                +--------------+
                |              |
                | AXI4         |
                | INTERCONNECT |
                |              |
                +--------------+
                  |     |     |
                  |     |     |
               +-----+ +-----+ +-----+
               | S0  | | S1  | | S2  |
               +-----+ +-----+ +-----+
```

## 🔄 AXI4 Protocol Overview

AXI4 consists of five independent channels:

| Channel | Description |
|---|---|
| AW | Write Address Channel |
| W | Write Data Channel |
| B | Write Response Channel |
| AR | Read Address Channel |
| R | Read Data Channel |

### Important AXI4 Features

- Independent read and write channels.
- VALID/READY handshake mechanism.
- Burst-based data transfers.
- Multiple outstanding transactions.
- Transaction identification using IDs.
- Backpressure handling.
- Byte-level write control using WSTRB.
- Error and response handling.

## 📦 Burst Transaction Verification

The project considers all three supported AXI4 burst types.

| Burst Type | AxBURST | Description |
|---|---|---|
| FIXED | 2'b00 | Address remains constant |
| INCR | 2'b01 | Address increments after each beat |
| WRAP | 2'b10 | Address wraps at burst boundary |

Additional verification includes:
- Different burst lengths.
- Different transfer sizes.
- Narrow transfers.
- Aligned and unaligned transfers.
- 4 KB address boundary conditions.

## 🧪 UVM Testbench Architecture

The verification environment follows a modular UVM architecture.

### Testbench Components

**1. Test**
- Controls the overall simulation.
- Starts master, slave, and reset sequences.

**2. Environment**
- Instantiates master agent top.
- Instantiates slave agent top.
- Instantiates reset agent top.
- Instantiates AXI scoreboard.

**3. Master Agents (2)**
Each master agent contains:
- Sequencer
- Driver
- Monitor

**4. Slave Agents (3)**
Each slave agent contains:
- Sequencer
- Driver
- Monitor

**5. Reset Agent**
- Generates reset sequences.
- Verifies reset behavior.

**6. Scoreboard**
- Receives transactions from master and slave monitors.
- Checks address routing.
- Compares write and read data.
- Checks transaction IDs and responses.
- Detects missing or duplicate transactions.

### UVM Architecture

```text
                  TOP
                   |
                  TEST
                   |
                  ENV
                   |
       +-----------+-----------+
       |           |           |
   Master Agent  Slave Agent  Reset Agent
     Top (2)      Top (3)        |
       |           |             |
   Sequencer   Sequencer      Sequencer
   Driver      Driver         Driver
   Monitor     Monitor        Monitor
       |           |
       +-----+-----+
             |
         Scoreboard
             |
       AXI4 INTERCONNECT
             |
          DUV / DUT
```

## ✅ Verification Plan

The following scenarios are considered in the verification plan:

| S.No | Verification Scenario |
|---|---|
| 1 | Master-to-slave connectivity (2 × 3) |
| 2 | Write burst transactions |
| 3 | Read burst transactions |
| 4 | FIXED, INCR and WRAP bursts |
| 5 | Multiple outstanding transactions |
| 6 | Out-of-order transactions |
| 7 | Aligned and unaligned transfers |
| 8 | Narrow transfers |
| 9 | All four slave responses |
| 10 | Simultaneous master requests |
| 11 | Reset verification |
| 12 | Data integrity checking |

## 🔍 AXI4 Response Verification

All four AXI4 response types are considered:

| Response | Encoding | Description |
|---|---|---|
| OKAY | 2'b00 | Successful transaction |
| EXOKAY | 2'b01 | Successful exclusive access |
| SLVERR | 2'b10 | Slave error |
| DECERR | 2'b11 | Decode error |

## 🛡️ Assertions

Protocol assertions are planned to check:

- VALID and READY handshake conditions.
- Signal stability during backpressure.
- Correct WLAST and RLAST assertion.
- Correct burst length.
- Correct transaction responses.
- Correct master response ownership.
- Correct slave address routing.
- No lost or duplicated transactions.
- Proper reset behavior.

## 📊 Functional Coverage

Functional coverage is planned for:

- All 2 × 3 master-slave combinations.
- Read and write transactions.
- All five AXI4 channels.
- FIXED, INCR and WRAP burst types.
- Burst lengths and transfer sizes.
- All four response types.
- Simultaneous requests from both masters.
- Same-slave and different-slave access.
- Cross coverage of Master × Slave × Read/Write.
- Cross coverage of Master × Slave × Burst Type.

## 📈 Waveform Analysis

Waveform analysis is used to understand and debug:

- Address channel handshakes.
- Write and read data transfers.
- VALID/READY timing.
- Burst beat count.
- WLAST and RLAST behavior.
- Response channel timing.
- Backpressure and wait states.

## ⚙️ Tools and Technologies

| Technology | Usage |
|---|---|
| SystemVerilog | Verification language |
| UVM | Verification methodology |
| AXI4 | Communication protocol |
| SVA | Protocol assertion checking |
| Functional Coverage | Verification coverage analysis |
| EDA Simulator | Simulation and debugging |

## 🚧 Verification Challenges

- Handling independent AXI4 channels under backpressure.
- Managing concurrent transactions from two masters.
- Matching master and slave transactions in the scoreboard.
- Verifying correct address routing.
- Checking response ownership using transaction IDs.
- Handling outstanding and out-of-order transactions.
- Verifying reset during active transactions.
- Covering different burst and response combinations.

## 🎓 Key Learning Outcomes

- Understanding AMBA AXI4 protocol architecture.
- Understanding multi-master and multi-slave interconnect functionality.
- Developing modular UVM testbench architecture.
- Working with UVM agents, drivers, monitors and sequences.
- Understanding scoreboard-based transaction checking.
- Applying assertions and functional coverage concepts.
- Debugging AXI4 transactions using waveforms.

## 👩‍💻 Author

**S. jahnavi **

VLSI Design and Verification



---

⭐ If you find this project useful, feel free to explore the repository and share your feedback.
