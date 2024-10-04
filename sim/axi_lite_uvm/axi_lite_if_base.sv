// axi_lite_if_base.sv

`ifndef __AXI_LITE_IF_BASE
`define __AXI_LITE_IF_BASE

class axi_lite_if_base extends uvm_component;

`uvm_component_utils(axi_lite_if_base)

function new(string name="axi_lite_if_base", uvm_component parent);
  super.new(name, parent);
endfunction

endclass

`endif
