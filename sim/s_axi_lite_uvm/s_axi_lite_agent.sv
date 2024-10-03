// s_axi_lite_agent.sv

`ifndef __S_AXI_LITE_AGENT
`define __S_AXI_LITE_AGENT

class s_axi_lite_agent extends uvm_agent;

`uvm_component_utils(s_axi_lite_agent)

s_axi_lite_monitor mon;

axi_lite_cfg cfg;

uvm_analysis_port #(axi_lite_seq_item) agent_ap;

function new(string name="s_axi_lite_agent", uvm_component parent);
  super.new(name, parent);
  `uvm_info("S AXI LITE AGENT", "constructor", UVM_LOW)
endfunction

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  `uvm_info("S AXI LITE AGENT", "build_phase", UVM_LOW)
  if (!uvm_config_db#(axi_lite_cfg)::get(this,"","axi_lite_agent_cfg",cfg)) begin
    `uvm_fatal("S AXI LITE AGENT", "failed to get configuration")
  end
  mon = s_axi_lite_monitor::type_id::create("mon", this);
  agent_ap = new("agent_ap", this);
endfunction

function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  `uvm_info("S AXI LITE AGENT", "connect_phase", UVM_LOW)
  agent_ap = mon.mon_ap;
endfunction

task run_phase(uvm_phase phase);
  super.run_phase(phase);
endtask

endclass

`endif
