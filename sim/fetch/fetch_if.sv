// fetch_if.sv

`default_nettype none

interface fetch_if # (
  parameter int XLEN = 64
)(
  input var clk,
  input var rstn
);

logic             jump_valid;
logic [XLEN-1:0]  jump_addr;
logic             branch_valid;
logic [XLEN-1:0]  branch_addr;

logic             halt_n;
logic [XLEN-1:0]  pc;
logic             pc_misalign;

endinterface
