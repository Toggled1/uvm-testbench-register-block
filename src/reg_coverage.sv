class reg_coverage extends uvm_subscriber #(reg_transaction);

  `uvm_component_utils(reg_coverage)

    reg_transaction tr;


  covergroup cg_reg_transaction;
    cp_addr: coverpoint tr.addr; //seperate bits for all 16 possible address made from 4 bits!
    cp_wr_en: coverpoint tr.wr_en {

    //example of creating bins!
      bins wr_en_0 = {0};
      bins wr_en_1 = {1};

    }
  endgroup

  function new(string name, uvm_component parent);
    super.new(name, parent);
    cg_reg_transaction = new();
  endfunction

  function void write(reg_transaction tr);

    this.tr = tr; //stores just the handle (NOTE: when not create(), this it just gets the handle)
    cg_reg_transaction.sample();

  endfunction
endclass