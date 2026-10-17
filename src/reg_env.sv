class reg_env extends uvm_env;

  `uvm_component_utils(reg_env)

  reg_agent      m_agent;
  reg_scoreboard m_scoreboard;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    m_agent      = reg_agent::type_id::create("m_agent", this);
    m_scoreboard = reg_scoreboard::type_id::create("m_scoreboard", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);

    super.connect_phase(phase);

    //connect the monitor to the scoreboard
    m_agent.m_monitor.mon_analysis_port.connect(m_scoreboard.ap_imp);
  endfunction

endclass