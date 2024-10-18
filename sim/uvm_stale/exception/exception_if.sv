// exception_if.sv

`default_nettype none

interface exception_if(
  input var clk,
  input var rstn
);

bit pc_addr_misalign;

endinterface
