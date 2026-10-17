class reg_monitor extends uvm_monitor;

  `uvm_component_utils(reg_monitor)

  virtual reg_if vif;
  uvm_analysis_port #(reg_transaction) mon_analysis_port;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mon_analysis_port = new("mon_analysis_port", this);
    if (!uvm_config_db #(virtual reg_if)::get(this, "", "vif", vif)) begin
      `uvm_fatal(get_type_name(), "Didn't get handle to virtual interface reg_if")
    end
  endfunction

  virtual task run_phase(uvm_phase phase);
    reg_transaction tr;

    forever begin
      @(posedge vif.clk);

      if (vif.wr_en) begin
        tr = reg_transaction::type_id::create("tr", this);
        tr.wr_en = 1;
        tr.addr  = vif.addr;
        tr.wdata = vif.wdata;
        mon_analysis_port.write(tr);
      end
      else if (vif.rd_en) begin
        tr = reg_transaction::type_id::create("tr", this);
        tr.rd_en = 1;
        tr.addr  = vif.addr;

        @(posedge vif.clk);
        tr.rdata = vif.rdata;

        mon_analysis_port.write(tr);
      end
    end
  endtask

endclass