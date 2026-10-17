module tb_top;


    //NOTE: tb top instantiates DUT, sets config_db for VIF, and runs the test!!!!

    // IT DOES NOT INSTANTIATE UVM COMPONENTS

  import uvm_pkg::*;
  import reg_pkg::*;
  `include "uvm_macros.svh"

  bit clk;
  always #10 clk = ~clk;

  reg_if    reg_if0 (clk);

  //instantiate the dut
  reg_block dut0    (reg_if0);

  initial begin
    reg_if0.rst_n = 0;
    reg_if0.wr_en = 0;
    reg_if0.rd_en = 0;
    #25 reg_if0.rst_n = 1;
  end

  initial begin

    //set vif for all with tag "vif"
    uvm_config_db #(virtual reg_if)::set(null, "uvm_test_top.*", "vif", reg_if0);

    //run the "reg_test"
    run_test("reg_test");
  end

endmodule