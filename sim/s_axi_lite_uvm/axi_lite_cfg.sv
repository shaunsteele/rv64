// axi_lite_cfg.sv

`ifndef __AXI_LITE_CFG
`define __AXI_LITE_CFG

class axi_lite_cfg extends uvm_object;

`uvm_object_utils(axi_lite_cfg)

int alen = 64;
int dlen = 64;
int slen = dlen / 8;

bit awen = 1;
bit wen = 1;
bit ben = 1;
bit aren = 1;
bit ren = 1;

function new(string name="axi_lite_cfg");
  super.new(name);
  `uvm_info("AXI LITE CFG", "constructor", UVM_LOW)
endfunction

endclass

`endif
