class reg_agent extends uvm_agent;

  `uvm_component_utils(reg_agent)

  reg_sequencer m_sequencer;
  reg_driver m_driver;
  reg_monitor m_monitor;
  reg_coverage m_coverage;

  function new(string name = "reg_agent", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    //only create sequencer and driver if the agent is active
    if(get_is_active()) begin
      m_sequencer = reg_sequencer::type_id::create("m_sequencer", this);
      m_driver = reg_driver::type_id::create("m_driver", this);
    end
    
    //always create monitor and coverage
      m_monitor = reg_monitor::type_id::create("m_monitor", this);
      m_coverage = reg_coverage::type_id::create("m_coverage", this);
  endfunction


  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    if(get_is_active()) begin
        //connect up driver and sequencer via analysis port - seq_item_port is part of `uvm_driver base class
        m_driver.seq_item_port.connect(m_sequencer.seq_item_export); 
    end

    //connect up monitor and coverage via analysis port - mon_analysis_port is NOT part of `uvm_monitor base class
    m_monitor.mon_analysis_port.connect(m_coverage.analysis_export);
        
  endfunction


endclass