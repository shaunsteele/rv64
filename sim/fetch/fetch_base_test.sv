// fetch_base_test.sv

`ifndef __FETCH_BASE_TEST
`define __FETCH_BASE_TEST

class fetch_base_test extends uvm_test;

`uvm_component_utils(fetch_base_test)

fetch_env env;

function new(string name="fetch_base_test", uvm_component parent);
  super.new(name, parent);
  `uvm_info("TEST", "top level fetch_base_test constructor", UVM_LOW);
endfunction

function void build_phase(uvm_phase phase);
  `uvm_info("TEST", "build_phase", UVM_LOW)
  env = fetch_env::type_id::create("env", this);
endfunction

task run_phase(uvm_phase phase);
  `uvm_info("TEST", "run_phase", UVM_LOW)
  phase.raise_objection(this);
  #1000;
  phase.drop_objection(this);
endtask

endclass

`endif
