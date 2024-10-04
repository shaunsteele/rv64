// fetch_env.sv

`ifndef __FETCH_ENV
`define __FETCH_ENV

class fetch_env extends uvm_env;

`uvm_component_utils(fetch_env)

axi_lite_agent  im_agent;
string im_if_string = "axi_lite_if_64_32";

function new(string name="fetch_env", uvm_component parent);
  super.new(name, parent);
  `uvm_info("ENV", "constructor", UVM_LOW)
endfunction

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  `uvm_info("ENV", "build_phase", UVM_LOW)

  im_agent = axi_lite_agent::type_id::create("im_agent", this);
  
  uvm_config_db#(string)::set(null,"*", "axi_lite_if_string", im_if_string);
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
