class reg_sequencer extends uvm_sequencer #(reg_transaction);

    `uvm_component_utils(reg_sequencer)

    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction

endclass