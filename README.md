# Register UVM Testbench

This UVM testbench verifies a simple memory-mapped register block with randomized reads and writes, transaction-level coverage, and a reference-model scoreboard.

The testbench follows the tutorial in [ChipVerify full UVM testbench tutorial](https://chipverify.com/uvm/full-uvm-testbench). This project was just for learning and UVM practice!!! (Refer to my MNIST CNN and 8-bit CPU to see my projects with a larger scope)

## Design

The DUT is a 16-entry by 8-bit memory:

- `addr` is 4 bits wide and selects one of 16 entries.
- `wdata` and `rdata` are 8 bits wide.
- `wr_en` writes `wdata` into the selected entry on a rising clock edge.
- `rd_en` loads the selected entry into `rdata` on a rising clock edge.
- A simultaneous write and read gives priority to the write.
- Active-low reset clears `rdata`; it does not initialize the memory entries.

The interface is declared in `src/reg_block.sv` as `reg_if`. The same file contains the `reg_block` DUT module.

## Testbench Structure

The test runs a sequence of 200 randomized transactions. The agent connects the sequencer to the driver and the monitor to coverage; the environment connects the monitor to the scoreboard.

- **Monitor:** Publishes observed bus transactions.
- **Coverage:** Samples addresses and operation types; no address/operation cross is defined.
- **Scoreboard:** Tracks writes in a reference memory and checks reads, skipping addresses not yet written.
- **Top and test:** `tb_top` instantiates the DUT and configures the virtual interface; `reg_test` creates the environment and starts the sequence.
