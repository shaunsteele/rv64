// axi_lite_cfg.sv

`ifndef __AXI_LITE_CFG
`define __AXI_LITE_CFG

class axi_lite_cfg extends uvm_object;

`uvm_object_utils(axi_lite_cfg)

string if_string = "axi_lite_if_64_64";

function new(string name="axi_lite_cfg");
  super.new(name);
  `uvm_info("AXI LITE CFG", "constructor", UVM_LOW)
endfunction

endclass

`endif
