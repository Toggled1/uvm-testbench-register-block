class reg_test extends uvm_test;

  `uvm_component_utils(reg_test)

  reg_env m_top_env;


  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    m_top_env = reg_env::type_id::create("m_top_env", this);
  endfunction

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
  endfunction

  virtual task run_phase(uvm_phase phase);

    //create sequence
    reg_sequence m_seq = reg_sequence::type_id::create("m_seq");


    phase.raise_objection(this);
    //start sequence on agent's sequencer!
    m_seq.start(m_top_env.m_agent.m_sequencer);
    phase.drop_objection(this);
  endtask

endclass