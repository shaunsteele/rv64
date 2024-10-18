// decode_agent.sv

`ifndef __DECODE_AGENT
`define __DECODE_AGENT

class decode_agent extends uvm_agent;

`uvm_component_utils(decode_agent)

decode_driver drv;
uvm_sequencer #(decode_seq_item)  sqr;
decode_monitor mon;
uvm_analysis_port #(decode_seq_item) ap;

function new(string name="decode_agent", uvm_component parent);
  super.new(name, parent);
  `uvm_info("AGENT","constructor",UVM_LOW)
endfunction

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  `uvm_info("AGENT","build_phase",UVM_LOW)
  drv = decode_driver::type_id::create("drv",this);
  sqr = uvm_sequencer #(decode_seq_item)::type_id::create("sqr",this);
  mon = decode_monitor::type_id::create("mon",this);
  ap = new("agent_ap",this);
endfunction

function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  `uvm_info("AGENT","connect_phase",UVM_LOW)
  drv.seq_item_port.connect(sqr.seq_item_export);
  ap = mon.ap;
endfunction

task run_phase(uvm_phase phase);
  super.run_phase(phase);
  `uvm_info("AGENT","run_phase",UVM_LOW)
endtask


endclass

`endif
