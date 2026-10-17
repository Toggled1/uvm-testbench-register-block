class reg_driver extends uvm_driver #(reg_transaction);

  `uvm_component_utils(reg_driver)

  virtual reg_if vif;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db #(virtual reg_if)::get(this, "", "vif", vif)) begin
      `uvm_fatal(get_type_name(), "Didn't get handle to virtual interface reg_if")
    end
  endfunction

  virtual task run_phase(uvm_phase phase);
    reg_transaction tr;

    forever begin
      seq_item_port.get_next_item(tr);

      @(posedge vif.clk);

      vif.wr_en <= tr.wr_en;
      vif.rd_en <= tr.rd_en;
      vif.addr  <= tr.addr;
      vif.wdata <= tr.wdata;

      @(posedge vif.clk);           // the DUT acts on this edge

     //here is where the monitor will now see wr_en or rd_en as asserted!

      vif.wr_en <= 0;
      vif.rd_en <= 0;

      if (tr.rd_en) begin
        @(posedge vif.clk);         // rdata is stable from here
        tr.rdata = vif.rdata;
      end

      seq_item_port.item_done();
    end
  endtask

endclass