// fetch_test_base.sv

`ifndef __FETCH_TEST_BASE
`define __FETCH_TEST_BASE

class fetch_test_base extends uvm_test;

`uvm_component_utils(fetch_test_base)

fetch_env env;
// env configuration
// axi lite configuration

function new(string name="fetch_test_base", uvm_component parent);
  super.new(name, parent);
  `uvm_info("TEST", "top level fetch_test_base constructor", UVM_LOW);
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
