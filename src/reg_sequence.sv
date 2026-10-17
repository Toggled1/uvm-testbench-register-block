class reg_sequence extends uvm_sequence #(reg_transaction);

  `uvm_object_utils(reg_sequence)

  function new(string name = "reg_sequence");
    super.new(name);
  endfunction

  virtual task pre_body();

  // "get_starting_phase" returns the UVM phase associated with this sequence.
    uvm_phase starting_phase = get_starting_phase();
    if (starting_phase != null) //this is just a check to make sure phase is set properly
      starting_phase.raise_objection(this);
   endtask

  virtual task body();
   repeat (5) begin

    req = reg_transaction::type_id::create("req");
    start_item(req);
    if (!req.randomize()) `uvm_fatal(get_type_name(), "Randomization failed")

    finish_item(req);

   end

  endtask

  virtual task post_body();
    uvm_phase starting_phase = get_starting_phase();
    if (starting_phase != null)
      starting_phase.drop_objection(this);
  endtask

endclass