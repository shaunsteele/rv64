// fetch_agent.sv

`ifndef __FETCH_AGENT
`define __FETCH_AGENT

class fetch_agent # (
  int XLEN = 64
) extends uvm_agent;

`uvm_component_utils(fetch_agent#(XLEN))

function new(string name="fetch_agent", uvm_component parent);
  super.new(name, parent);
endfunction

// fetch_driver#(XLEN) drv;
// fetch_monitor#(XLEN)  mon;

endclass

`endif
