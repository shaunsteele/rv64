// store_base_test.sv

`ifndef __STORE_BASE_TEST
`define __STORE_BASE_TEST

class store_base_test extends uvm_test;

`uvm_component_utils(store_base_test)

function new(string name="store_base_test", uvm_component parent);
  super.new(name, parent);
  `uvm_info("TEST", "top level store_base_test constructor", UVM_LOW)
endfunction

function void build_phase(uvm_phase phase);
  `uvm_info("TEST", "build_phase", UVM_LOW)
endfunction

task run_phase(uvm_phase phase);
  `uvm_info("TEST", "run_phase", UVM_LOW)
  phase.raise_objection(this);
  #1000;
  phase.drop_objection(this);
endtask

endclass

`endif
