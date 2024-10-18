// decode_env.sv

`ifndef __DECODE_ENV
`define __DECODE_ENV

class decode_env extends uvm_env;

`uvm_component_utils(decode_env)

decode_agent agent;

function new(string name="decode_env", uvm_component parent);
  super.new(name, parent);
  `uvm_info("ENV","constructor",UVM_LOW)
endfunction

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  `uvm_info("ENV","build_phase",UVM_LOW)
  agent = decode_agent::type_id::create("agent",this);
endfunction

function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  `uvm_info("ENV","connect_phase",UVM_LOW)
endfunction

task run_phase(uvm_phase phase);
  `uvm_info("ENV","run_phase",UVM_LOW)
endtask

endclass

`endif
