interface reg_if (input bit clk);
  logic        rst_n;
  logic        wr_en;
  logic        rd_en;
  logic [3:0]  addr;
  logic [7:0]  wdata;
  logic [7:0]  rdata;

  // Property to check that control signals are known (not X or Z)
  property p_known_control;
    @(posedge clk) disable iff (!rst_n)
    !$isunknown({wr_en, rd_en});
  endproperty
  no_x: assert property (p_known_control)
  else `uvm_error("REG_IF", "Unknown value detected in control signals")

  // Property to check for valid request addr
  property p_known_address;
    @(posedge clk) disable iff (!rst_n)
    (wr_en | rd_en) |-> !($isunknown(addr));
  endproperty
  addr_valid: assert property (p_known_address)
  else `uvm_error("REG_IF", "Invalid address detected in request")

  // Property to check for valid write data
  property p_known_wdat;
    @(posedge clk) disable iff (!rst_n)
    (wr_en) |-> !($isunknown(wdata));
  endproperty
  wdata_valid: assert property (p_known_wdat)
  else `uvm_error("REG_IF", "Unknown value detected in write data")


  
endinterface

module reg_block (reg_if vif);

  logic [7:0] mem [0:15];

  always_ff @(posedge vif.clk or negedge vif.rst_n) begin

    // Reset
    if (!vif.rst_n) begin
      vif.rdata <= 8'h00;
    end else begin

      // Write
      if (vif.wr_en) begin
        mem[vif.addr] <= vif.wdata;

      //Read
      end else if (vif.rd_en) begin
        vif.rdata <= mem[vif.addr];
      end
    end
  end

endmodule
