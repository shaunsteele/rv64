// fetch_env.sv

`ifndef __FETCH_ENV
`define __FETCH_ENV

class fetch_env extends uvm_env;

`uvm_component_utils(fetch_env)

s_axi_lite_agent  im_agent;

function new(string name="fetch_env", uvm_component parent);
  super.new(name, parent);
  `uvm_info("ENV", "constructor", UVM_LOW)
endfunction

function void build_phase(uvm_phase phase);
  axi_lite_cfg im_cfg;
  super.build_phase(phase);
  `uvm_info("ENV", "build_phase", UVM_LOW)
  im_agent = s_axi_lite_agent::type_id::create("im_agent", this);
  im_cfg = axi_lite_cfg::type_id::create("im_cfg", this);
  im_cfg.alen = 64;
  im_cfg.dlen = 32;
  im_cfg.awen = 0;
  im_cfg.wen = 0;
  im_cfg.aren = 1;
  im_cfg.ren = 0;
  uvm_config_db#(axi_lite_cfg)::set(this,"im_agent*", "axi_lite_cfg", im_cfg);
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
