// fetch_env.sv

`ifndef __FETCH_ENV
`define __FETCH_ENV

class fetch_env extends uvm_env;

`uvm_component_utils(fetch_env)

function new(string name="fetch_env", uvm_component parent);
  super.new(name, parent);
  `uvm_info("ENV", "constructor", UVM_LOW)
endfunction

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  `uvm_info("ENV", "build_phase", UVM_LOW)
endfunction

function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  `uvm_info("ENV", "connect_phase", UVM_LOW)
endfunction

task run_phase(uvm_phase phase);
  `uvm_info("ENV", "run_phase", UVM_LOW)
endtask

endclass

`endif
