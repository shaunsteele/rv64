// decode_test.sv

`ifndef __DECODE_TEST
`define __DECODE_TEST

class decode_test extends uvm_test;

`uvm_component_utils(decode_test)

decode_env env;

function new(string name="decode_test", uvm_component parent);
  super.new(name, parent);
  `uvm_info("TEST","top level decod_test constructor",UVM_LOW)
endfunction

function void build_phase(uvm_phase phase);
  `uvm_info("TEST","build_phase",UVM_LOW)
  env = decode_env::type_id::create("env",this);
endfunction

task run_phase(uvm_phase phase);
  `uvm_info("TEST","run_phase",UVM_LOW)
  phase.raise_objection(this);
  #1000;
  phase.drop_objection(this);
endtask

endclass

`endif
