// exception_if.sv

`default_nettype none

interface exception_if(
  input var clk,
  input var rstn
);

logic pc_addr_misalign;
logic invalid_opcode; 

endinterface
