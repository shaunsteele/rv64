// axi_lite_agent.sv

`ifndef __AXI_LITE_AGENT
`define __AXI_LITE_AGENT

class axi_lite_agent # (
  int ALEN = 64,
  int DLEN = 64,
  string IF_NAME = "axi"
) extends uvm_agent;

`uvm_component_utils(axi_lite_agent#(ALEN,DLEN,IF_NAME))

axi_lite_monitor#(ALEN,DLEN,IF_NAME) mon;
// axi_lite_cfg cfg;

// uvm_analysis_port #(axi_lite_seq_item) agent_ap;

function new(string name="axi_lite_agent", uvm_component parent);
  super.new(name, parent);
  `uvm_info(get_name(), "constructor", UVM_LOW)
endfunction

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  `uvm_info(get_name(), "build_phase", UVM_LOW)
  // if (!uvm_config_db#(axi_lite_cfg)::get(this,"","axi_lite_cfg",cfg)) begin
  //   `uvm_fatal(get_name(), "failed to get configuration")
  // end
  mon = axi_lite_monitor#(ALEN,DLEN,IF_NAME)::type_id::create("mon", this);
  // agent_ap = new("agent_ap", this);
endfunction

function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  `uvm_info(get_name(), "connect_phase", UVM_LOW)
  // agent_ap = mon.mon_ap;
endfunction

task run_phase(uvm_phase phase);
  super.run_phase(phase);
endtask

endclass

`endif
