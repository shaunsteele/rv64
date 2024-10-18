// axi_lite_if_class.sv

`ifndef __AXI_LITE_IF_CLASS
`define __AXI_LITE_IF_CLASS

class axi_lite_if_class # (
  int alen = 64,
  int dlen = 64,
  int slen = dlen / 8
) extends axi_lite_if_base;

`uvm_component_param_utils(axi_lite_if_class#(alen, dlen, slen))

function new(string name="axi_lite_if_class", uvm_component parent);
  super.new(name, parent);
endfunction

endclass

`endif
